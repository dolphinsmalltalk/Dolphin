/*
=======
Lexer.h
=======
The Smalltalk lexical analyser
*/
#pragma once

///////////////////////
#include "Str.h"

///////////////////////

class Lexer
{
	
	// Replace CRT strtol(), which is too flexible for Smalltalk lexicon
	long strtol (
        const char *nptr,
        char **endptr,
        int ibase
        );
	
	// This is the strtol() function cloned from the CRT library
	unsigned long strtoxl (
        const char *nptr,
        const char **endptr,
        int ibase,
        int flags
        );
	
protected:
	// The current lexical token
	enum TokenType 
	{ 
		// Type for parsing
		None, NameConst, NameColon, 
			SmallIntegerConst, LargeIntegerConst, FloatingConst, ScaledDecimalConst, CharConst, 
			SymbolConst, TrueConst, FalseConst, NilConst,
			ArrayBegin, ByteArrayBegin, StringConst, ExprConstBegin, Special,
			Binary, Return, Assignment, CloseParen, CloseStatement, CloseSquare, CloseBrace, Cascade, Eof 
	};
	
public:
	Lexer();
	virtual ~Lexer();
	
	char Step();
	void PushBack(char ch);
	VOID StepBack(int n);
	TokenType NextToken();
	void ScanString(int);
	void ScanNumber();
	int DigitValue(char ch) const;
	void ScanInteger(int radix);
	void ScanFloat();
	void ScanExponentInteger();
	void ScanIdentifierOrKeyword();
	void ScanName();
	void ScanQualifiedRef();
	void ScanLiteral();
	void ScanLiteralCharacter();
	void ScanSymbol();
	void ScanBinary();
	int ReadHexCodePoint();
	
	TokenType ThisToken() const;
	void SetTokenType(TokenType tok);
	bool AtEnd() const;
	const char* ThisTokenText() const;
	long ThisTokenInteger() const;
	double ThisTokenFloat() const;
	bool ThisTokenIsBinary(const char) const;
	bool ThisTokenIsSpecial(const char) const;
	bool ThisTokenIsClosing() const;
	bool ThisTokenIsAssignment() const;
	bool ThisTokenIsReturn() const;
	bool ThisTokenIsNumber() const;
	
	void CompileError(const TEXTRANGE& range, int code, Oop extra=0);
	void CompileError(int code, Oop extra=0);	
	void CompileErrorV(const TEXTRANGE& range, int code, ...);

protected:
	virtual void _CompileErrorV(int code, const TEXTRANGE& range, va_list)=0;

	
	char PeekAtChar(int lookAhead=0) const;
	//bool CanBeSmallInteger(long valueLong) const;
	bool IsASingleBinaryChar(char ch) const;
	//bool IsDigitInRadix(char ch, int radix) const;
	
	TEXTRANGE CompileTextRange() const
	{
		return TEXTRANGE(0, GetTextLength()-1);
	}

	//******************************************************************************
	// ANSI X3J20 Compliant Lexicon (added by BSM)
	//******************************************************************************
	static bool isNonCaseLetter(char ch);
	static bool isLetter(char ch);
	static bool isIdentifierFirst(char ch);
	static bool isIdentifierSubsequent(char ch);
	static bool isAnsiBinaryChar(char ch);
	
	static bool isupper(char ch);
	static bool islower(char ch);
	static bool isdigit(char ch);
	static bool isspace(char ch);
	
	void SkipBlanks();
	void SkipComments();

	void SetText(const char* compiletext, int offset);

	const char* GetText() const
	{
		return m_buffer.c_str();
	}

	int GetTextOffset() const
	{
		return m_base;
	}

	int GetParsedLength() const
	{
		return m_cp - GetText() - GetTextOffset();
	}

	const TEXTRANGE& ThisTokenRange() const
	{
		return m_thisTokenRange;
	}

	const TEXTRANGE& LastTokenRange() const
	{
		return m_lastTokenRange;
	}

	int ErrorPosition() const
	{
		return AtEnd() ? ThisTokenRange().m_stop : LastTokenRange().m_stop;
	}

	int GetTextLength() const
	{
		return m_buffer.size();
	}

	const char* GetCharPtr() const
	{
		return m_cp;
	}

	char GetNextChar() const
	{
		return *m_cp;
	}

	int GetLineNo() const
	{
		return m_lineno;
	}

	void AdvanceCharPtr(int offset)
	{
		m_cp += offset;
	}

	int CharPosition() const;

private:
	char NextChar();

private:
	// The current token
	TokenType m_tokenType;
	long m_integer;
	char* m_token;
	char* tp;
	
	// Buffer state
	Str m_buffer;
	const char* m_cp;
	char m_cc;
	int m_lineno;
	int m_base;
	
	TEXTRANGE m_thisTokenRange;
	TEXTRANGE m_lastTokenRange;
};
	
///////////////////////////////////////////////////////////////////////////////
// Inlines

inline Lexer::TokenType Lexer::ThisToken() const
{
	return m_tokenType;
}

inline bool Lexer::AtEnd() const
{
	return m_tokenType == Eof;
}

inline const char* Lexer::ThisTokenText() const
{
	return m_token;
}

inline long Lexer::ThisTokenInteger() const
{
	return m_integer; 
}

inline double Lexer::ThisTokenFloat() const
{
	return atof(m_token);
}

inline bool Lexer::ThisTokenIsAssignment() const
{
	return m_tokenType == Assignment;
}

inline bool Lexer::ThisTokenIsReturn() const
{
	return m_tokenType == Return;
}

inline bool Lexer::ThisTokenIsBinary(const char match) const
{
	return m_tokenType==Binary && m_token[0] == match && m_token[1] == 0;
}

inline bool Lexer::ThisTokenIsSpecial(const char match) const
{
	return m_tokenType==Special && m_token[0] == match && m_token[1] == 0;
}

inline bool Lexer::ThisTokenIsClosing() const
{
	return m_tokenType >= CloseParen && m_tokenType <= Eof;
}

inline bool Lexer::ThisTokenIsNumber() const
{
	return m_tokenType >= SmallIntegerConst && m_tokenType <= ScaledDecimalConst; 
}

inline void Lexer::SetTokenType(TokenType tok)
{
	m_tokenType = tok;
}

inline char Lexer::NextChar()
{
	m_cc=*m_cp ? *m_cp++ : '\0';
	if (m_cc=='\n')
		m_lineno++;
	return m_cc;
}

inline char Lexer::Step()
{
	char ch = NextChar();
	if (ch)
	{
		*tp++ = ch;
		*tp = 0;
		m_thisTokenRange.m_stop++;
	}
	return ch;
}

inline char Lexer::PeekAtChar(int lookAhead) const
{
	return m_cp[lookAhead];
}

inline int Lexer::CharPosition() const
{
	return (m_cp - m_buffer.c_str()) - 1;
}

inline void Lexer::PushBack(char ch)
{
	_ASSERTE(m_cp>m_buffer.c_str());
	if (ch)
	{
		--m_cp;
		_ASSERTE(*m_cp == ch);
		m_cc = ch;
		if (m_cc=='\n')
		{
			_ASSERTE(m_lineno>1);
			m_lineno--;
		}
	}
}

// N.B. This routine assumes it is not stepping back over line ends
inline void Lexer::StepBack(int n)
{
	m_cp -= n;
	m_cc = *m_cp;
	m_thisTokenRange.m_stop -= n;
	m_token[m_thisTokenRange.m_stop - m_thisTokenRange.m_start + 1] = 0;
}

//******************************************************************************
// ANSI X3J20 Compliant Lexicon (added by BSM)
//
// N.B. These must not be internationalized (currently)
//******************************************************************************

inline bool Lexer::isNonCaseLetter(char c) 
{
	return c == '_';
}

inline bool Lexer::isupper(char c) 
{
	return c >= 'A' && c <= 'Z';
}

inline bool Lexer::islower(char c) 
{
	return c >= 'a' && c <= 'z';
}

inline bool Lexer::isLetter(char c) 
{
	return islower(c) || isupper(c) || isNonCaseLetter(c); 
}

inline bool Lexer::isdigit(char c) 
{
	return c >= '0' && c <= '9';
}

inline bool Lexer::isIdentifierFirst(char c)
{
	return isLetter(c);
}

inline bool Lexer::isIdentifierSubsequent(char c)
{
	return isLetter(c) || isdigit(c);
}

inline bool Lexer::isspace(char c) 
{
	return c == 0x20 || (c >= 0x09 && c <= 0x0D);
}
