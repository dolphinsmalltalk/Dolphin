/******************************************************************************

	File: STStackFrame.h

	Description:

	VM representation of Smalltalk stack frames (not real objects),

******************************************************************************/

#ifndef _IST_STStackFrame_H_
#define _IST_STStackFrame_H_

#include "STContext.h"
#include "STMethod.h"

// Stack frame layout - not a real object.
struct StackFrame
{
	MethodOTE*	m_method;			// Oop of method for which this frame is an activation
	Oop			m_environment;		// Oop of Environment object, if any, otherwise SmallInteger zero
	Oop			m_caller;			// Process index of sending StackFrame
	Oop			m_ip;				// Index into byte codes of method
	Oop			m_sp;				// Process index of top of stack for this frame
	Oop			m_bp;				// SmallInteger BP - always points into stack now

	Oop* stackPointer()	const	{ return reinterpret_cast<Oop*>(m_sp-1); }
	void setStackPointer(Oop* value);
	void setInstructionPointer(int nOffset);
	Oop* basePointer() const;
	BOOL isBlockFrame() const;
	Oop	 receiver() const;
	BOOL hasContext() const;

	StackFrame* caller() const
	{
		return FromFrameOop(m_caller);
	}

	static StackFrame* FromFrameOop(Oop frameIndex);
};
	
///////////////////////////////////////////////////////////////////////////////
inline void StackFrame::setStackPointer(Oop* value)
{
	ASSERT(!(Oop(value)&1));
	m_sp = Oop(value)+1;
}

inline void StackFrame::setInstructionPointer(int nOffset)
{
	m_ip = integerObjectOf(nOffset);
}

inline Oop* StackFrame::basePointer() const
{
	ASSERT(isIntegerObject(m_bp));
	return reinterpret_cast<Oop*>(m_bp - 1);
}

inline BOOL StackFrame::hasContext() const
{
	return !isIntegerObject(m_environment);
}

inline BOOL StackFrame::isBlockFrame() const
{
	return hasContext() ? reinterpret_cast<ContextOTE*>(m_environment)->m_location->isBlockContext() : FALSE;
}

inline StackFrame* StackFrame::FromFrameOop(Oop framePointer)
{
	HARDASSERT(isIntegerObject(framePointer));
	return reinterpret_cast<StackFrame*>(framePointer-1);
}

inline Oop StackFrame::receiver() const
{
	return basePointer()[-1];
}

#endif
