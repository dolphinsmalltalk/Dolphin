#include "stdafx.h"
#include "Compiler.h"
#include <minmax.h>

#pragma warning(disable:4786)	// Browser identifier truncated to 255 characters

#pragma warning(push,3)
#pragma warning(disable:4530)
#include <iostream>
#include <iomanip>
#include <sstream>
#pragma warning(pop)
using namespace std;

#include "..\tracestream.h"
tracestream debugStream;

void Compiler::disassemble()
{
	tracelock lock(debugStream);
	debugStream << noshowbase << nouppercase << setfill(L' ');
	disassemble(debugStream);
}

void Compiler::disassemble(wostream& stream)
{
	int maxDepth = 0;
	for (size_t i = 0; i < m_allScopes.size(); i++)
	{
		int depth = m_allScopes[i]->GetLogicalDepth();
		if (depth > maxDepth) maxDepth = depth;
	}

	LexicalScope* currentScope = m_allScopes[0];
	int currentDepth = 0;
	stream << std::endl;
	size_t i=0;
	const size_t size = GetCodeSize();
	BytecodeDisassembler<Compiler> disassembler(*this);
	while (i < size)
	{
		disassembler.EmitIp(i, stream);
		size_t len = disassembler.EmitRawBytes(i, stream);

		// Scope changing, and getting deeper?
		LexicalScope* newScope = m_bytecodes[i].pScope;
		stream << newScope << L' ';

		char padChar = ' ';
		// If new nested scope, want to print opening bracket
		if (currentScope != newScope)
		{
			int newDepth = newScope->GetLogicalDepth();
			if (!(newDepth < currentDepth))
			{
				padChar = '-';
			}
			currentScope = m_bytecodes[i].pScope;
			currentDepth = newDepth;
		}

		// If next is in outer scope, want to print closing bracket now
		bool lastInstr = i + len >= size;
		int nextDepth = lastInstr ? 0 : m_bytecodes[i + len].pScope->GetLogicalDepth();

		// If not on last bytecode, and scope will change, close the bracket
		if (nextDepth < currentDepth)
		{
			padChar = '-';
		}

		int j;
		for (j = 0; j < currentDepth; j++)
		{
			stream<< L"|";
		}
		for (; j <= maxDepth; j++)
		{
			stream << padChar;
		}

		const TEXTMAPLIST::iterator it = FindTextMapEntry(i);
		if (it != m_textMaps.end())
			stream << L'`';
		else
			stream << L' ';

		disassembler.EmitDecodedInstructionAt(i, stream);
		i += len;
	}
	stream << std::endl;
}

Str Compiler::GetSpecialSelector(size_t index)
{
	const POTE* pSpecialSelectors = GetVMPointers().specialSelectors;
	return GetString(pSpecialSelectors[index]);
}

std::wstring Compiler::DebugPrintString(Oop oop)
{
	BSTR bstr = m_piVM->DebugPrintString(oop);
	std::wstring result(bstr, ::SysStringLen(bstr));
	::SysFreeString(bstr);
	return result;
}

