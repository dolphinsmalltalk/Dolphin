/******************************************************************************

	File: OopQ.cpp

	Description:

	Implementation of the OopQueue class

******************************************************************************/

#include "Ist.h"

#ifndef _DEBUG
	#pragma optimize("s", on)
	#pragma auto_inline(off)
#endif

#pragma code_seg(PROCESS_SEG)

#include "OopQ.h"
#include "ObjMem.h"

// Smalltalk Classes
#include "STArray.h"		// Queues are stored in Arrays

///////////////////////////////////////////////////////////////////////////////
// OopQueue public members

OopQueue::OopQueue() : m_bufferArray(0), m_pBuffer(0), 
	m_nHead(0), m_nTail(0), m_nGrowthGranularity(0), m_nSize(0) {}

OopQueue::OopQueue(OTE* bufferArray, MWORD nGrowthGranularity)
{
	UseBuffer(bufferArray, nGrowthGranularity);
}

void OopQueue::UseBuffer(POTE bufferArray, MWORD nGrowthGranularity, bool bShrink)
{
	m_bufferArray = bufferArray;
	m_nGrowthGranularity = nGrowthGranularity;
	ASSERT(ObjectMemory::fetchClassOf(Oop(bufferArray)) == Pointers.ClassArray);
	Array array = m_bufferArray->m_location;
	m_nSize = array->PointerSize();
	ASSERT(m_nSize >= 2);
	m_pBuffer = array->m_elements;

	// Now find the head and tail

	// Skip tail (head always points at an empty slot)
	const Oop nil = Oop(Pointers.Nil);
	while (m_pBuffer[m_nHead] != nil)
		m_nHead = (m_nHead + 1) % m_nSize;

	while (m_pBuffer[m_nHead] == nil && m_nHead < m_nSize)
		m_nHead++;

	if (m_nHead == m_nSize)
	{
		// Its empty
		m_nHead = m_nTail = 0;
#ifndef _AFX
		if (bShrink)
		{
			m_nSize = m_nGrowthGranularity;
			m_pBuffer = ObjectMemory::resizePointers(m_bufferArray, m_nSize)->m_elements;
		}
#endif
	}
	else
	{
		m_nTail = m_nHead--;
		while (m_pBuffer[m_nTail] != nil)
			m_nTail = (m_nTail + 1) % m_nSize;
	}
}

// Nothing important to do on destruct at present
OopQueue::~OopQueue() {}

void OopQueue::onCompact()
{ 
	ObjectMemory::compactOop(m_bufferArray); 
}

void OopQueue::Push(const Oop objectPointer)
{
	ASSERT(m_pBuffer);
	if (++m_nTail == m_nSize)		// Conditional check much quicker than division required for remainder
		m_nTail = 0;	
	if (m_nTail == m_nHead)
		Overflow();
	// Take a reference to the object when appending to queue
	ObjectMemory::countUp(objectPointer);
	m_pBuffer[m_nTail] = objectPointer;
}

// Answered Oop has artificially raised ref. count
Oop OopQueue::Pop()
{
	if (isEmpty())
		return Underflow();
	m_nHead = (m_nHead + 1) % m_nSize;
	Oop objectPointer = m_pBuffer[m_nHead];
	m_pBuffer[m_nHead] = Oop(Pointers.Nil);
	return objectPointer;
}

///////////////////////////////////////////////////////////////////////////////
// OopQueue private members

// Private - The queue overflowed, grow it to accomodate more elements
void OopQueue::Overflow()
{
	MWORD oldSize = m_nSize;
	m_nSize += m_nGrowthGranularity;
	m_pBuffer = ObjectMemory::resizePointers(m_bufferArray, m_nSize)->m_elements;
	if (m_nTail == 0)
		// We don't want the tail to wrap around to 0, as we've now increased the size
		m_nTail = oldSize;
	else
	{
		// The queue is split i.e. it has wrapped around, so we need to
		// move those elements between the front and the old size so that they
		// end at old size (this is quite likely to be an overlapping move).
		const MWORD numToMove = oldSize - m_nHead;
		const Oop nil = Oop(Pointers.Nil);
		for (unsigned i=1;i<=numToMove;i++)
		{
			m_pBuffer[m_nSize-i] = m_pBuffer[oldSize-i];
			m_pBuffer[oldSize-i] = nil;
		}
		m_nHead = m_nSize-numToMove;

		// The newly calculated tail value will be correct
	}
}

Oop OopQueue::Underflow()
{
	return Oop(Pointers.Nil);
}
