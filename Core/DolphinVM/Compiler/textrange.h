#pragma once

#include "..\EnumHelpers.h"

enum class textpos_t : intptr_t { npos = -1, start };
ENABLE_INT_OPERATORS(textpos_t)

struct TEXTRANGE
{
	textpos_t m_start;
	textpos_t m_stop;

	TEXTRANGE(textpos_t start = textpos_t::start, textpos_t stop = textpos_t::npos) : m_start(start), m_stop(stop)
	{}

	__declspec(property(get = GetSpan)) intptr_t Span;
	intptr_t GetSpan() const { return (intptr_t)m_stop - (intptr_t)m_start + 1; }
};

