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

typedef const uint8_t* LPUTF8;

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
			ArrayBegin, ByteArrayBegin, AnsiStringConst, Utf8StringConst, ExprConstBegin, Special,
			Binary, Return, Assignment, CloseParen, CloseStatement, CloseSquare, CloseBrace, Cascade, Eof 
	};
	
public:
	Lexer();
	virtual ~Lexer();
	
	uint8_t Step();
	void PushBack(uint8_t ch);
	VOID StepBack(int n);
	TokenType NextToken();
	TokenType ScanString(int);
	void ScanNumber();
	int DigitValue(uint8_t ch) const;
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
	
	TokenType ThisToken() const;
	void SetTokenType(TokenType tok);
	bool AtEnd() const;
	LPUTF8 ThisTokenText() const;
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
	enum { MaxCodePoint = 0x10FFFF };

	virtual void _CompileErrorV(int code, const TEXTRANGE& range, va_list)=0;

	
	uint8_t PeekAtChar(int lookAhead=0) const;
	//bool CanBeSmallInteger(long valueLong) const;
	bool IsASingleBinaryChar(uint8_t ch) const;
	//bool IsDigitInRadix(char ch, int radix) const;
	
	TEXTRANGE CompileTextRange() const
	{
		return TEXTRANGE(0, GetTextLength()-1);
	}

	//******************************************************************************
	// ANSI X3J20 Compliant Lexicon (added by BSM)
	//******************************************************************************
	static bool isNonCaseLetter(uint8_t ch);
	static bool isLetter(uint8_t ch);
	static bool isIdentifierFirst(uint8_t ch);
	static bool isIdentifierSubsequent(uint8_t ch);
	static bool isAnsiBinaryChar(uint8_t ch);
	
	static bool isupper(uint8_t ch);
	static bool islower(uint8_t ch);
	static bool isdigit(uint8_t ch);
	static bool isspace(uint8_t ch);
	
	void SkipBlanks();
	void SkipComments();

	void SetText(const uint8_t* compiletext, int offset);

	LPUTF8 GetText() const
	{
		return m_buffer.c_str();
	}

	Str GetTextRange(const TEXTRANGE& r)
	{
		return m_buffer.substr(r.m_start, r.m_stop - r.m_start + 1);
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

	const uint8_t* GetCharPtr() const
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

	IDolphin* m_piVM;

private:
	int ReadUtf8();
	int ReadUtf8(uint8_t ch);
	int ReadHexCodePoint();
	uint8_t NextChar();

private:
	// The current token
	TokenType m_tokenType;
	long m_integer;
	uint8_t* m_token;
	uint8_t* tp;
	
	// Buffer state
	Str m_buffer;
	const uint8_t* m_cp;
	uint8_t m_cc;
	int m_lineno;
	int m_base;
	
	TEXTRANGE m_thisTokenRange;
	TEXTRANGE m_lastTokenRange;

	_locale_t m_locale;
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

inline LPUTF8 Lexer::ThisTokenText() const
{
	return m_token;
}

inline long Lexer::ThisTokenInteger() const
{
	return m_integer; 
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

inline uint8_t Lexer::NextChar()
{
	m_cc=*m_cp ? *m_cp++ : '\0';
	if (m_cc == '\n')
		m_lineno++;
	return m_cc;
}

inline uint8_t Lexer::Step()
{
	uint8_t ch = NextChar();
	if (ch)
	{
		*tp++ = ch;
		*tp = 0;
		m_thisTokenRange.m_stop++;
	}
	return ch;
}

inline uint8_t Lexer::PeekAtChar(int lookAhead) const
{
	return m_cp[lookAhead];
}

inline int Lexer::CharPosition() const
{
	return (m_cp - m_buffer.c_str()) - 1;
}

inline void Lexer::PushBack(uint8_t ch)
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

inline bool Lexer::isNonCaseLetter(uint8_t c)
{
	return c == '_';
}

inline bool Lexer::isupper(uint8_t c)
{
	return c >= 'A' && c <= 'Z';
}

inline bool Lexer::islower(uint8_t c)
{
	return c >= 'a' && c <= 'z';
}

inline bool Lexer::isLetter(uint8_t c) 
{
	return islower(c) || isupper(c) || isNonCaseLetter(c); 
}

inline bool Lexer::isdigit(uint8_t c)
{
	return c >= '0' && c <= '9';
}

inline bool Lexer::isIdentifierFirst(uint8_t c)
{
	return isLetter(c);
}

inline bool Lexer::isIdentifierSubsequent(uint8_t c)
{
	return isLetter(c) || isdigit(c);
}

inline bool Lexer::isspace(uint8_t c)
{
	return c == 0x20 || (c >= 0x09 && c <= 0x0D);
}
