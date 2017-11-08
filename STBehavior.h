/******************************************************************************

	File: STBehavior.h

	Description:

	VM representation of Smalltalk Behavior classes. These are fundamental
	to the VM's execution machinery.

	N.B. The classes here defined are well known to the VM, and must not
	be modified in the image. Note also that these classes may also have
	a representation in the assembler modules (so see istasm.inc)

******************************************************************************/
#pragma once

#include "STObject.h"
#include "STArray.h"

union InstanceSpecification
{
	struct
	{
		WORD m_isInt : 1;	// MUST be 1 (to avoid treatment as object)
		WORD m_fixedFields : 8;	// Number of instance variables (must be zero for byte objects)
		WORD m_unusedSpecBits : 1;
		WORD m_nonInstantiable : 1;	// The Behavior should not be instantiated, e.g. it is abstract
		WORD m_mourner : 1;	// Notify weak instances of the receiver when they suffer bereavements
		WORD m_indirect : 1;	// Byte object containing address of another object/external structure?
		WORD m_indexable : 1;	// variable or variableByte subclass?
		WORD m_pointers : 1;	// Pointers or bytes?
		WORD m_nullTerminated : 1;	// Null terminated byte object?

		WORD m_extraSpec;				// High word for class specific purposes (e.g. structure byte size)
	};
	DWORD m_value;

	enum
	{
		NonInstantiableMask = 1 << 10,
		MournerMask = 1 << 11,
		IndirectMask = 1 << 12,
		IndexableMask = 1 << 13,
		PointersMask = 1 << 14,
		NullTermMask = 1 << 15
	};
};


// Declare forward references
namespace ST
{
	class Behavior;
	class MethodDictionary;
}
typedef TOTE<ST::Behavior> BehaviorOTE;
typedef TOTE<ST::MethodDictionary> MethodDictOTE;

namespace ST
{
	class Behavior //: public Object
	{
	public:
		BehaviorOTE*			m_superclass;
		MethodDictOTE*			m_methodDictionary;
		InstanceSpecification	m_instanceSpec;
		ArrayOTE*				m_subclasses;

	public:
		unsigned fixedFields() const { return (*reinterpret_cast<const DWORD*>(&m_instanceSpec) >> 1) & 0xFF; }
		BOOL isPointers() const { return m_instanceSpec.m_pointers; }
		BOOL isBytes() const { return !m_instanceSpec.m_pointers; }
		BOOL isIndexable() const { return m_instanceSpec.m_indexable; }
		BOOL isMourner() const { return m_instanceSpec.m_mourner; }
		WORD extraSpec() const { return m_instanceSpec.m_extraSpec; }
		BOOL isIndirect() const { return m_instanceSpec.m_indirect; }

		enum {
			SuperclassIndex = ObjectFixedSize, MethodDictionaryIndex, InstanceSpecificationIndex,
			SubClassesIndex, FixedSize
		};
	};
}
extern ostream& operator<<(ostream& stream, const BehaviorOTE*);
