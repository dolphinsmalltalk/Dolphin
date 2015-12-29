/******************************************************************************

	File: STHashedCollection.h

	Description:

	VM representation of Smalltalk collection classes.

	N.B. Some of the classes here defined are well known to the VM, and must not
	be modified in the image. Note also that these classes may also have
	a representation in the assembler modules (so see istasm.inc)

	The VM doesn't care about the implementation of dictionaries really, and
	only represent it here because we do care about the implementation
	of MethodDictionary

******************************************************************************/

#ifndef _IST_STHASHEDCOLLECTION_H_
#define _IST_STHASHEDCOLLECTION_H_

#include "STCollection.h"


class SetBase : public Collection
{
public:
	Oop m_tally;

	enum { TallyIndex=Collection::FixedSize, FixedSize };
};

class Set : public SetBase
{
public:
	Oop	m_elements[];
};

class MethodDictionary : public SetBase
{
public:
	ArrayOTE*	m_methods;			// Offset 1 (MethodArrayIndex) - External Array of values (see inherited m_elements)
	SymbolOTE*	m_selectors[];		// Offset 2 (SelectorStart) - Internal array of keys

	enum { MethodArrayIndex=SetBase::FixedSize, FixedSize };
};

typedef TOTE<MethodDictionary> MethodDictOTE;

#endif	// EOF