/******************************************************************************

	File: STClassDesc.h

	Description:

	VM representation of Smalltalk ClassDescription class and subclasses.
	This level of specialization is not used by the VM, which works at the
	Behavior level only

******************************************************************************/
#pragma once

#include "STBehavior.h"

// Declare forward references
namespace ST 
{ 
	class Class;
	class MetaClass;
	class ClassDescription;
}
typedef TOTE<ST::Class> ClassOTE;
typedef TOTE<ST::MetaClass> MetaClassOTE;
typedef TOTE<ST::ClassDescription> ClassDescriptionOTE;

namespace ST
{
	class ClassDescription : public Behavior
	{
	public:
		ArrayOTE* m_instanceVariables;
		POTE		m_methodsCatalogue;
		POTE		m_protocols;

		static constexpr size_t InstanceVariablesIndex = Behavior::FixedSize;
		static constexpr size_t MethodsCatalogueIndex = InstanceVariablesIndex + 1;
		static constexpr size_t ProtocolsIndex = MethodsCatalogueIndex + 1;
		static constexpr size_t FixedSize = ProtocolsIndex + 1;
	};

	class Class : public ClassDescription
	{
	public:
		// TODO: Use Utf8String
		AnsiStringOTE*	m_name;
		POTE		m_classPool;	/* dictionary of varName, storage */
		POTE		m_sharedPools;
		POTE		m_comment;
		POTE		m_classCategories;
		POTE		m_guid;

		static constexpr size_t NameIndex = ClassDescription::FixedSize;
		static constexpr size_t ClassPoolIndex = NameIndex + 1;
		static constexpr size_t SharedPoolsIndex = ClassPoolIndex + 1;
		static constexpr size_t CommentIndex = SharedPoolsIndex + 1;
		static constexpr size_t ClassCategoriesIndex = CommentIndex + 1;
		static constexpr size_t GUIDIndex = ClassCategoriesIndex + 1;
		static constexpr size_t FixedSize = GUIDIndex + 1;

#if defined(_DEBUG)
		__declspec(property(get = getName)) LPCSTR Name;
		LPCSTR getName() const
		{
			return m_name->m_location->m_characters;
		}
#endif
	};

	class MetaClass : public ClassDescription
	{
	public:
		ClassOTE* m_instanceClass;

		static constexpr size_t InstanceClassIndex = ClassDescription::FixedSize;
		static constexpr size_t FixedSize = InstanceClassIndex + 1;
	};

	class StringClass : Class
	{
	public:
		__declspec(property(get = getEncoding)) StringEncoding Encoding;
		StringEncoding getEncoding() const { return m_instanceSpec.m_encoding; }
	};
}

std::wostream& operator<<(std::wostream& stream, const ST::Class& cl);