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
}
typedef TOTE<ST::Class> ClassOTE;
typedef TOTE<ST::MetaClass> MetaClassOTE;

namespace ST
{
	class ClassDescription : public Behavior
	{
	public:
		StringOTE*	m_instanceVariables;
		POTE		m_methodsCatalogue;
		POTE		m_protocols;

		enum { InstanceVariablesIndex = Behavior::FixedSize, MethodsCatalogueIndex, ProtocolsIndex, FixedSize };
	};

	class Class : public ClassDescription
	{
	public:
		StringOTE*	m_name;
		POTE		m_classPool;	/* dictionary of varName, storage */
		POTE		m_sharedPools;
		POTE		m_comment;
		POTE		m_classCategories;
		POTE		m_guid;

		enum {
			NameIndex = ClassDescription::FixedSize, ClassPoolIndex,
			SharedPoolsIndex, CommentIndex, ClassCategoriesIndex, GUIDIndex, FixedSize
		};

#if defined(_DEBUG)
		const char* getName()
		{
			return m_name->m_location->m_characters;
		}
#endif
	};

	class MetaClass : public ClassDescription
	{
	public:
		ClassOTE*	m_instanceClass;

		enum { InstanceClassIndex = ClassDescription::FixedSize, FixedSize };
	};
}

extern ostream& operator<<(ostream& stream, const ST::Class& cl);