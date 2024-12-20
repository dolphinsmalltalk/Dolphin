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
	unsigned maxDepth = 0;
	for (size_t i = 0; i < m_allScopes.size(); i++)
	{
		unsigned depth = m_allScopes[i]->GetLogicalDepth();
		if (depth > maxDepth) maxDepth = depth;
	}

	LexicalScope* currentScope = m_allScopes[0];
	unsigned currentDepth = 0;
	stream << endl;
	ip_t ip=ip_t::zero;
	const ip_t last = LastIp;
	BytecodeDisassembler<Compiler, ip_t> disassembler(*this);
	while (ip <= LastIp)
	{
		disassembler.EmitIp(ip, stream);
		size_t len = disassembler.EmitRawBytes(ip, stream);

		// Scope changing, and getting deeper?
		LexicalScope* newScope = m_bytecodes[ip].pScope;
		stream << newScope << L' ';

		char padChar = ' ';
		// If new nested scope, want to print opening bracket
		if (currentScope != newScope)
		{
			unsigned newDepth = newScope->GetLogicalDepth();
			if (!(newDepth < currentDepth))
			{
				padChar = '-';
			}
			currentScope = m_bytecodes[ip].pScope;
			currentDepth = newDepth;
		}

		// If next is in outer scope, want to print closing bracket now
		bool lastInstr = ip + len > last;
		unsigned nextDepth = lastInstr ? 0 : m_bytecodes[ip + len].pScope->GetLogicalDepth();

		// If not on last bytecode, and scope will change, close the bracket
		if (nextDepth < currentDepth)
		{
			padChar = '-';
		}

		unsigned j;
		for (j = 0; j < currentDepth; j++)
		{
			stream<< L"|";
		}
		for (; j <= maxDepth; j++)
		{
			stream << padChar;
		}

		const TEXTMAPLIST::iterator it = FindTextMapEntry(ip);
		if (it != m_textMaps.end())
			stream << L'`';
		else
			stream << L' ';

		disassembler.EmitDecodedInstructionAt(ip, stream);
		ip += len;
	}
	stream << endl;
}

u8string Compiler::GetSpecialSelector(size_t index)
{
	const POTE* pSpecialSelectors = GetVMPointers().specialSelectors;
	return GetString(pSpecialSelectors[index]);
}

wstring Compiler::DebugPrintString(Oop oop)
{
	BSTR bstr = m_piVM->DebugPrintString(oop);
	wstring result(bstr, ::SysStringLen(bstr));
	::SysFreeString(bstr);
	return result;
}

wostream& __stdcall operator<<(wostream& stream, const string& str)
{
	size_t cch = str.size();
	std::unique_ptr<WCHAR[]> buf(new WCHAR[cch]);
	::MultiByteToWideChar(CP_ACP, MB_PRECOMPOSED, str.data(), cch, buf.get(), cch);
	return stream << buf;
}
