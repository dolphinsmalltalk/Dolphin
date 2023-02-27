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
	
	int Step();
	void PushBack(int ch);
	void StepBack(size_t n);
	TokenType NextToken();
	TokenType ScanString(textpos_t);
	void ScanNumber();
	int DigitValue(int ch) const;

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
	
	__declspec(property(get = get_ThisTokenType, put=put_ThisTokenType)) TokenType ThisTokenType;
	Lexer::TokenType get_ThisTokenType() const
	{
		return m_tokenType;
	}
	void put_ThisTokenType(TokenType tok)
	{
		m_tokenType = tok;
	}

	__declspec(property(get = get_AtEnd)) bool AtEnd;
	bool get_AtEnd() const
	{
		return m_tokenType == TokenType::Eof;
	}

	__declspec(property(get = get_ThisTokenRaw)) LPUTF8 ThisTokenRaw;
	LPUTF8 get_ThisTokenRaw() const
	{
		return m_token;
	}

	__declspec(property(get = get_ThisTokenText)) u8string ThisTokenText;
	u8string get_ThisTokenText() const
	{
		return u8string(m_token, ThisTokenLength);
	}

	__declspec(property(get = get_ThisTokenInteger)) intptr_t ThisTokenInteger;
	intptr_t get_ThisTokenInteger() const
	{
		return m_integer;
	}

	__declspec(property(get = get_ThisTokenFloat)) double ThisTokenFloat;
	double get_ThisTokenFloat() const;

	bool ThisTokenIsBinary(const char8_t) const;
	bool ThisTokenIsSpecial(const char8_t) const;

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

	void Warning(int code, Oop extra = 0);
	void Warning(const TEXTRANGE& range, int code, Oop extra = 0);
	void WarningV(const TEXTRANGE& range, int code, ...);

	void CompileError(const TEXTRANGE& range, int code, Oop extra=0);
	void CompileError(int code, Oop extra=0);	
	void CompileErrorV(const TEXTRANGE& range, int code, ...);

protected:
	static constexpr char32_t MaxCodePoint = UCHAR_MAX_VALUE;

	virtual void _CompileErrorV(int code, const TEXTRANGE& range, va_list) = 0;
	virtual void _CompileWarningV(int code, const TEXTRANGE& range, va_list) = 0;
	
	int PeekAtChar(size_t lookAhead=0) const;
	bool IsASingleBinaryChar(int ch) const;
	
	TEXTRANGE CompileTextRange() const
	{
		return TEXTRANGE(textpos_t::start, EndOfText);
	}

	//******************************************************************************
	// ANSI X3J20 Compliant Lexicon (added by BSM)
	//******************************************************************************
	static bool isNonCaseLetter(int ch);
	static bool isLetter(int ch);
	static bool isIdentifierFirst(int ch);
	static bool isIdentifierSubsequent(int ch);
	static bool isAnsiBinaryChar(int ch);
	
	static bool isupper(int ch);
	static bool islower(int ch);
	static bool isdigit(int ch);
	static bool isspace(int ch);
	static bool isEof(int ch);

	bool AtEof();
	
	void SkipBlanks();
	void SkipComments();

	void SetText(const u8string& compiletext, textpos_t offset);

	__declspec(property(get = get_Text)) const u8string& Text;
	const u8string& get_Text() const
	{
		return m_buffer;
	}

	u8string GetTextRange(const TEXTRANGE& r)
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
		return m_cp - m_buffer.data() - static_cast<size_t>(TextOffset);
	}

	__declspec(property(get = get_ThisTokenRange)) const TEXTRANGE& ThisTokenRange;
	const TEXTRANGE& get_ThisTokenRange() const
	{
		return m_thisTokenRange;
	}

	__declspec(property(get = get_ThisTokenLength)) const size_t ThisTokenLength;
	const size_t get_ThisTokenLength() const
	{
		return m_tp - m_token;
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
		return m_buffer.length();
	}

	__declspec(property(get = get_EndOfText)) textpos_t EndOfText;
	textpos_t get_EndOfText() const
	{
		return static_cast<textpos_t>(m_buffer.length() - 1);
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
		return static_cast<textpos_t>((m_cp - m_buffer.data()) - 1);
	}

	IDolphin* m_piVM;
	VMPointers* m_pVMPointers;

private:
	int32_t DecodeUtf8();
	int32_t DecodeUtf8(char8_t ch);
	int32_t ReadHexCodePoint();
	int NextChar();

private:
	// The current token
	TokenType m_tokenType;
	intptr_t m_integer;
	char8_t* m_token;
	char8_t* m_tp;
	
	// Buffer state
	u8string m_buffer;
	const char8_t* m_cp;
	const char8_t* m_end;
	int m_cc;
	int m_lineno;
	textpos_t m_base;
	
	TEXTRANGE m_thisTokenRange;
	TEXTRANGE m_lastTokenRange;

	static _locale_t m_locale;
};
	
///////////////////////////////////////////////////////////////////////////////
// Inlines

inline bool Lexer::ThisTokenIsBinary(const char8_t match) const
{
	return m_tokenType== TokenType::Binary && m_token[0] == match && ThisTokenLength == 1;
}

inline bool Lexer::ThisTokenIsSpecial(const char8_t match) const
{
	return m_tokenType== TokenType::Special && m_token[0] == match && ThisTokenLength == 1;
}

inline int Lexer::NextChar()
{
	if (m_cp < m_end)
	{
		m_cc = *m_cp++;
		if (m_cc == u8'\n')
			m_lineno++;
	}
	else
	{
		m_cc = EOF;
	}
	return m_cc;
}

inline int Lexer::Step()
{
	int ch = NextChar();
	if (!isEof(ch))
	{
		*m_tp++ = ch;
		++m_thisTokenRange.m_stop;
	}
	return ch;
}

inline int Lexer::PeekAtChar(size_t lookAhead) const
{
	return m_cp + lookAhead < m_end ? m_cp[lookAhead] : EOF;
}

inline void Lexer::PushBack(int ch)
{
	_ASSERTE(m_cp>m_buffer.data());
	if (!isEof(ch))
	{
		--m_cp;
		_ASSERTE(*m_cp == ch);
		m_cc = ch;
		if (m_cc == u8'\n')
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
	m_tp -= n;
}

//******************************************************************************
// ANSI X3J20 Compliant Lexicon (added by BSM)
//
// N.B. These must not be internationalized (currently)
//******************************************************************************

inline bool Lexer::isNonCaseLetter(int c)
{
	return c == u8'_';
}

inline bool Lexer::isupper(int c)
{
	return c >= u8'A' && c <= u8'Z';
}

inline bool Lexer::islower(int c)
{
	return c >= u8'a' && c <= u8'z';
}

inline bool Lexer::isLetter(int c)
{
	return islower(c) || isupper(c) || isNonCaseLetter(c); 
}

inline bool Lexer::isdigit(int c)
{
	return c >= u8'0' && c <= u8'9';
}

inline bool Lexer::isIdentifierFirst(int c)
{
	return isLetter(c);
}

inline bool Lexer::isIdentifierSubsequent(int c)
{
	return isLetter(c) || isdigit(c);
}

inline bool Lexer::isspace(int c)
{
	return c == u8' ' || (c >= 0x09 && c <= 0x0D);
}

inline bool Lexer::isEof(int c)
{
	return c < 0;
}

inline bool Lexer::AtEof()
{
	return isEof(m_cc);
}
