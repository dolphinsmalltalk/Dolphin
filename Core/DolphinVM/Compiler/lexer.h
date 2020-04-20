/*
=======
Lexer.h
=======
The Smalltalk lexical analyser
*/
#pragma once

///////////////////////
#include "Str.h"
#include "textrange.h"

///////////////////////

typedef const char8_t* LPUTF8;

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
	enum class TokenType 
	{ 
		// Type for parsing
		None, NameConst, NameColon, 
			SmallIntegerConst, LargeIntegerConst, FloatingConst, ScaledDecimalConst, CharConst, 
			SymbolConst, TrueConst, FalseConst, NilConst,
			ArrayBegin, ByteArrayBegin, QualifiedRefBegin, AsciiStringConst, Utf8StringConst, ExprConstBegin, Special,
			Binary, Return, Assignment, CloseParen, CloseStatement, CloseSquare, CloseBrace, Cascade, Eof 
	};
	
public:
	Lexer();
	virtual ~Lexer();
	
	char8_t Step();
	void PushBack(char8_t ch);
	void StepBack(size_t n);
	TokenType NextToken();
	TokenType ScanString(textpos_t);
	void ScanNumber();
	int DigitValue(char8_t ch) const;

	enum class radix_t { Min = 2, Decimal=10, Hex=16, Max = 36 };
	void ScanInteger(radix_t radix);
	void ScanFloat();
	void ScanExponentInteger();
	void ScanIdentifierOrKeyword();
	void ScanName();
	void ScanQualifiedName();
	void ScanLiteral();
	void ScanLiteralCharacter();
	void ScanSymbol();
	void ScanBinary();
	
	__declspec(property(get = get_ThisToken, put=put_ThisToken)) TokenType ThisToken;
	Lexer::TokenType get_ThisToken() const
	{
		return m_tokenType;
	}
	void put_ThisToken(TokenType tok)
	{
		m_tokenType = tok;
	}

	__declspec(property(get = get_AtEnd)) bool AtEnd;
	bool get_AtEnd() const
	{
		return m_tokenType == TokenType::Eof;
	}

	__declspec(property(get = get_ThisTokenText)) LPUTF8 ThisTokenText;
	LPUTF8 get_ThisTokenText() const
	{
		return m_token;
	}

	__declspec(property(get = get_ThisTokenInteger)) intptr_t ThisTokenInteger;
	intptr_t get_ThisTokenInteger() const
	{
		return m_integer;
	}

	__declspec(property(get = get_ThisTokenFloat)) double ThisTokenFloat;
	double get_ThisTokenFloat() const;

	bool ThisTokenIsBinary(const char) const;
	bool ThisTokenIsSpecial(const char) const;

	__declspec(property(get = get_ThisTokenIsClosing)) bool ThisTokenIsClosing;
  	bool get_ThisTokenIsClosing() const
	{
		return m_tokenType >= TokenType::CloseParen && m_tokenType <= TokenType::Eof;
	}

	__declspec(property(get = get_ThisTokenIsAssignment)) bool ThisTokenIsAssignment;
	bool get_ThisTokenIsAssignment() const
	{
		return m_tokenType == TokenType::Assignment;
	}

	__declspec(property(get = get_ThisTokenIsReturn)) bool ThisTokenIsReturn;
	bool get_ThisTokenIsReturn() const
	{
		return m_tokenType == TokenType::Return;
	}

	__declspec(property(get = get_ThisTokenIsNumber)) bool ThisTokenIsNumber;
	bool get_ThisTokenIsNumber() const
	{
		return m_tokenType >= TokenType::SmallIntegerConst && m_tokenType <= TokenType::ScaledDecimalConst;
	}


	void CompileError(const TEXTRANGE& range, int code, Oop extra=0);
	void CompileError(int code, Oop extra=0);	
	void CompileErrorV(const TEXTRANGE& range, int code, ...);

protected:
	static constexpr char32_t MaxCodePoint = MAX_UCSCHAR;

	virtual void _CompileErrorV(int code, const TEXTRANGE& range, va_list)=0;
	
	char8_t PeekAtChar(size_t lookAhead=0) const;
	bool IsASingleBinaryChar(char8_t ch) const;
	
	TEXTRANGE CompileTextRange() const
	{
		return TEXTRANGE(textpos_t::start, EndOfText);
	}

	//******************************************************************************
	// ANSI X3J20 Compliant Lexicon (added by BSM)
	//******************************************************************************
	static bool isNonCaseLetter(char8_t ch);
	static bool isLetter(char8_t ch);
	static bool isIdentifierFirst(char8_t ch);
	static bool isIdentifierSubsequent(char8_t ch);
	static bool isAnsiBinaryChar(char8_t ch);
	
	static bool isupper(char8_t ch);
	static bool islower(char8_t ch);
	static bool isdigit(char8_t ch);
	static bool isspace(char8_t ch);
	
	void SkipBlanks();
	void SkipComments();

	void SetText(const char8_t* compiletext, textpos_t offset);

	__declspec(property(get = get_Text)) LPUTF8 Text;
	LPUTF8 get_Text() const
	{
		return m_buffer.c_str();
	}

	Str GetTextRange(const TEXTRANGE& r)
	{
		return m_buffer.substr(static_cast<size_t>(r.m_start), r.Span);
	}

	__declspec(property(get = get_TextOffset)) textpos_t TextOffset;
	textpos_t get_TextOffset() const
	{
		return m_base;
	}

	__declspec(property(get = get_ParsedLength)) size_t ParsedLength;
	size_t get_ParsedLength() const
	{
		return m_cp - Text - static_cast<size_t>(TextOffset);
	}

	__declspec(property(get = get_ThisTokenRange)) const TEXTRANGE& ThisTokenRange;
	const TEXTRANGE& get_ThisTokenRange() const
	{
		return m_thisTokenRange;
	}

	__declspec(property(get = get_LastTokenRange)) const TEXTRANGE& LastTokenRange;
	const TEXTRANGE& get_LastTokenRange() const
	{
		return m_lastTokenRange;
	}

	__declspec(property(get = get_ErrorPosition)) textpos_t ErrorPosition;
	textpos_t get_ErrorPosition() const
	{
		return AtEnd ? ThisTokenRange.m_stop : LastTokenRange.m_stop;
	}

	__declspec(property(get=get_TextLength)) size_t TextLength;
	size_t get_TextLength() const
	{
		return m_buffer.size();
	}

	__declspec(property(get = get_EndOfText)) textpos_t EndOfText;
	textpos_t get_EndOfText() const
	{
		return static_cast<textpos_t>(m_buffer.size() - 1);
	}

	__declspec(property(get = get_CharPtr)) const char8_t* CharPtr;
	const char8_t* get_CharPtr() const
	{
		return m_cp;
	}

	__declspec(property(get = get_LineNo)) int LineNo;
	int get_LineNo() const
	{
		return m_lineno;
	}

	void AdvanceCharPtr(size_t offset)
	{
		m_cp += offset;
	}

	__declspec(property(get = get_CharPosition)) textpos_t CharPosition;
	textpos_t get_CharPosition() const
	{
		return static_cast<textpos_t>((m_cp - m_buffer.c_str()) - 1);
	}

	IDolphin* m_piVM;

private:
	int32_t ReadUtf8();
	int32_t ReadUtf8(char8_t ch);
	int32_t ReadHexCodePoint();
	char8_t NextChar();

private:
	// The current token
	TokenType m_tokenType;
	intptr_t m_integer;
	char8_t* m_token;
	char8_t* tp;
	
	// Buffer state
	Str m_buffer;
	const char8_t* m_cp;
	char8_t m_cc;
	int m_lineno;
	textpos_t m_base;
	
	TEXTRANGE m_thisTokenRange;
	TEXTRANGE m_lastTokenRange;

	_locale_t m_locale;
};
	
///////////////////////////////////////////////////////////////////////////////
// Inlines

inline bool Lexer::ThisTokenIsBinary(const char match) const
{
	return m_tokenType== TokenType::Binary && m_token[0] == match && m_token[1] == 0;
}

inline bool Lexer::ThisTokenIsSpecial(const char match) const
{
	return m_tokenType== TokenType::Special && m_token[0] == match && m_token[1] == 0;
}

inline char8_t Lexer::NextChar()
{
	m_cc=*m_cp ? *m_cp++ : '\0';
	if (m_cc == '\n')
		m_lineno++;
	return m_cc;
}

inline char8_t Lexer::Step()
{
	char8_t ch = NextChar();
	if (ch)
	{
		*tp++ = ch;
		*tp = 0;
		++m_thisTokenRange.m_stop;
	}
	return ch;
}

inline char8_t Lexer::PeekAtChar(size_t lookAhead) const
{
	return m_cp[lookAhead];
}

inline void Lexer::PushBack(char8_t ch)
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
inline void Lexer::StepBack(size_t n)
{
	m_cp -= n;
	m_cc = *m_cp;
	m_thisTokenRange.m_stop -= n;
	m_token[m_thisTokenRange.Span] = 0;
}

//******************************************************************************
// ANSI X3J20 Compliant Lexicon (added by BSM)
//
// N.B. These must not be internationalized (currently)
//******************************************************************************

inline bool Lexer::isNonCaseLetter(char8_t c)
{
	return c == '_';
}

inline bool Lexer::isupper(char8_t c)
{
	return c >= 'A' && c <= 'Z';
}

inline bool Lexer::islower(char8_t c)
{
	return c >= 'a' && c <= 'z';
}

inline bool Lexer::isLetter(char8_t c)
{
	return islower(c) || isupper(c) || isNonCaseLetter(c); 
}

inline bool Lexer::isdigit(char8_t c)
{
	return c >= '0' && c <= '9';
}

inline bool Lexer::isIdentifierFirst(char8_t c)
{
	return isLetter(c);
}

inline bool Lexer::isIdentifierSubsequent(char8_t c)
{
	return isLetter(c) || isdigit(c);
}

inline bool Lexer::isspace(char8_t c)
{
	return c == 0x20 || (c >= 0x09 && c <= 0x0D);
}
