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
		uint16_t m_isInt : 1;	// MUST be 1 (to avoid treatment as object)
		uint16_t m_fixedFields : 8;	// Number of instance variables (must be zero for byte objects)
		uint16_t m_unusedSpecBits : 1;
		uint16_t m_nonInstantiable : 1;	// The Behavior should not be instantiated, e.g. it is abstract
		uint16_t m_mourner : 1;	// Notify weak instances of the receiver when they suffer bereavements
		uint16_t m_indirect : 1;	// Byte object containing address of another object/external structure?
		uint16_t m_indexable : 1;	// variable or variableByte subclass?
		uint16_t m_pointers : 1;	// Pointers or bytes?
		uint16_t m_nullTerminated : 1;	// Null terminated byte object?

		union
		{
			uint16_t m_extraSpec : 16;				// High word for class specific purposes (e.g. structure byte size)
			struct
			{
				ST::StringEncoding m_encoding : 2;
				uint8_t : 6;
				uint8_t : 8;
			};
		};
	};
	SmallUinteger m_value;

	enum
	{
		NonInstantiableMask = 1 << 10,
		MournerMask = 1 << 11,
		IndirectMask = 1 << 12,
		IndexableMask = 1 << 13,
		PointersMask = 1 << 14,
		NullTermMask = 1 << 15,
		FixedFieldsMask = 0xFF << 1
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
	typedef uint8_t instvarcount_t;

	class Behavior //: public Object
	{
	public:
		BehaviorOTE*			m_superclass;
		MethodDictOTE*			m_methodDictionary;
		InstanceSpecification	m_instanceSpec;

	public:
		instvarcount_t fixedFields() const { return (m_instanceSpec.m_value >> 1) & UINT8_MAX; }
		BOOL isPointers() const { return m_instanceSpec.m_pointers; }
		BOOL isBytes() const { return !m_instanceSpec.m_pointers; }
		BOOL isIndexable() const { return m_instanceSpec.m_indexable; }
		BOOL isMourner() const { return m_instanceSpec.m_mourner; }
		uint16_t extraSpec() const { return m_instanceSpec.m_extraSpec; }
		BOOL isIndirect() const { return m_instanceSpec.m_indirect; }

		static constexpr size_t SuperclassIndex = Object::FixedSize;
		static constexpr size_t MethodDictionaryIndex = SuperclassIndex + 1;
		static constexpr size_t InstanceSpecificationIndex = MethodDictionaryIndex + 1;
		static constexpr size_t FixedSize = InstanceSpecificationIndex + 1;
	};
}

std::wostream& operator<<(std::wostream& stream, const BehaviorOTE*);
