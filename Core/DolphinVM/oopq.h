/******************************************************************************

	File: OopQ.h

	Description:

	Ring Buffer for Oops

******************************************************************************/
#pragma once

#include "ote.h"
#include "ObjMem.h"
#include "STArray.h"

template <typename T> class OopQueue
{
public:

	// instantiation

	OopQueue() : m_bufferArray(0), m_pBuffer(0), 
		m_nHead(0), m_nTail(0), m_nGrowthGranularity(0), m_nSize(0) {}

	OopQueue(OTE* bufferArray, size_t nGrowthGranularity)
	{
		UseBuffer(bufferArray, nGrowthGranularity);
	}

	// initialization
	void UseBuffer(ArrayOTE* bufferArray, size_t nGrowthGranularity, bool bShrink)
	{
		m_bufferArray = bufferArray;
		m_nGrowthGranularity = nGrowthGranularity;
		ASSERT(ObjectMemory::fetchClassOf(Oop(bufferArray)) == Pointers.ClassArray);
		Array& array = *m_bufferArray->m_location;
		m_nSize = bufferArray->pointersSize();
		ASSERT(m_nSize >= 2);
		m_pBuffer = reinterpret_cast<T*>(array.m_elements);

		// Now find the head and tail

		// Skip tail (head always points at an empty slot)
		const T nil = reinterpret_cast<T>(Pointers.Nil);
		while (m_pBuffer[m_nHead] != nil)
			m_nHead = (m_nHead + 1) % m_nSize;

		while (m_pBuffer[m_nHead] == nil && m_nHead < m_nSize)
			m_nHead++;

		if (m_nHead == m_nSize)
		{
			// Its empty
			m_nHead = m_nTail = 0;
			if (bShrink)
			{
				m_nSize = m_nGrowthGranularity;
				m_pBuffer = reinterpret_cast<T*>(ObjectMemory::resize(
						reinterpret_cast<PointersOTE*>(m_bufferArray), m_nSize, false)->m_fields);
			}
		}
		else
		{
			size_t next = m_nHead--;
			ASSERT(m_pBuffer[next] != nil);
			do
			{
				m_nTail = next;
				next = (next + 1) % m_nSize;
			} while (m_pBuffer[next] != nil);
			ASSERT(m_pBuffer[m_nTail] != nil);
		}
		ASSERT(m_pBuffer[m_nHead] == nil);
	}

	// accessing
	void Push(T objectPointer)
	{
		ASSERT(m_pBuffer != nullptr);
		__assume(m_pBuffer != nullptr);

		if (++m_nTail == m_nSize)		// Conditional check much quicker than division required for remainder
			m_nTail = 0;	
		if (m_nTail == m_nHead)
			Overflow();
		// Take a reference to the object when appending to queue
		ObjectMemory::countUp(Oop(objectPointer));
		m_pBuffer[m_nTail] = objectPointer;
	}

	// Answered Oop has artificially raised ref. count
	T Pop()
	{
		if (isEmpty())
			return Underflow();
		m_nHead = (m_nHead + 1) % m_nSize;
		T objectPointer = m_pBuffer[m_nHead];
		m_pBuffer[m_nHead] = reinterpret_cast<T>(Pointers.Nil);
		return objectPointer;
	}

	// Return the number of elements in the queue
	size_t Count()
	{
		// Remember the slot pointed at by m_hHead is empty
		return m_nTail < m_nHead ? m_nSize - m_nHead + m_nTail : m_nTail - m_nHead;
	}

	// testing
	bool isFull() const
	{
		ASSERT(m_pBuffer);
		return m_nHead == (m_nTail+1) % m_nSize;
	}

	bool isEmpty() const
	{
		ASSERT(m_pBuffer);
		return m_nHead == m_nTail;
	}

	void onCompact()
	{ 
		ObjectMemory::compactOop(m_bufferArray); 
	}

private:
	// The queue overflowed, grow it to accomodate more elements
	void Overflow()
	{
		size_t oldSize = m_nSize;
		m_nSize += m_nGrowthGranularity;
		m_pBuffer = reinterpret_cast<T*>(ObjectMemory::resize(reinterpret_cast<PointersOTE*>(m_bufferArray), m_nSize, false)->m_fields);
		if (m_nTail == 0)
			// We don't want the tail to wrap around to 0, as we've now increased the size
			m_nTail = oldSize;
		else
		{
			// The queue is split i.e. it has wrapped around, so we need to
			// move those elements between the front and the old size so that they
			// end at old size (this is quite likely to be an overlapping move).
			const size_t numToMove = oldSize - m_nHead;
			const T nil = reinterpret_cast<T>(Pointers.Nil);
			for (size_t i=1;i<=numToMove;i++)
			{
				m_pBuffer[m_nSize-i] = m_pBuffer[oldSize-i];
				m_pBuffer[oldSize-i] = nil;
			}
			m_nHead = m_nSize-numToMove;

			// The newly calculated tail value will be correct
		}
	}

	T Underflow()
	{
		return reinterpret_cast<T>(Pointers.Nil);
	}

private:
	ArrayOTE*	m_bufferArray;			// Object pointer of buffer (an Array)
	T*			m_pBuffer;				// Pointer to the elements of the above
	size_t		m_nHead;				// Head of queue, from where items popped: Index of free slot before first item in queue
	size_t		m_nTail;				// Tail of queue, to where items pushed: Index of last item in queue
	size_t		m_nSize;				// Current queue size
	size_t 		m_nGrowthGranularity;	// The number of pointers by which to grow on overflow
};
