/*
=======
Lex.cpp
=======
Smalltalk lexical analyser
*/

///////////////////////

#include "stdafx.h"
#include "Lexer.h" 
#include "Str.h"
#include <icu.h>

#ifdef DOWNLOADABLE
#include "downloadableresource.h"
#else
#include "..\compiler_i.h"
#endif

static const char8_t COMMENTDELIM = u8'"';
static const char8_t STRINGDELIM = u8'\'';
static const char8_t CHARLITERAL = u8'$';
static const char8_t LITERAL = u8'#';

///////////////////////

// Createing a _locale_t is quite slow, and we only need one after all, so make it static
_locale_t Lexer::m_locale = _create_locale(LC_ALL, "C");

Lexer::Lexer()
{
	m_base = textpos_t::start;
	m_cc = -1;
	m_cp = nullptr;
	m_integer = 0;
	m_lastTokenRange = { textpos_t::start, textpos_t::start };
	m_lineno = 0;
	m_thisTokenRange = { textpos_t::start, textpos_t::start };
	m_token = nullptr;
	m_tokenType = TokenType::None;
	m_tp = nullptr;
	m_piVM = nullptr;
	m_pVMPointers = nullptr;
}

Lexer::~Lexer()
{
	delete[] m_token;
}

void Lexer::CompileError(int code, Oop extra)
{
	CompileErrorV(ThisTokenRange, code, extra, 0);
}

void Lexer::CompileError(const TEXTRANGE& range, int code, Oop extra)
{
	CompileErrorV(range, code, extra, 0);
}

void Lexer::CompileErrorV(const TEXTRANGE& range, int code, ...)
{
	va_list extras;
	va_start(extras, code);
	_CompileErrorV(code, range, extras);
	va_end(extras);
}

void Lexer::SetText(const u8string& compiletext, textpos_t offset)
{
	m_tokenType = TokenType::None;
	m_buffer = compiletext;
	m_cp = m_buffer.data();
	size_t textLength = compiletext.size();
	m_end = m_cp + textLength;
	m_token = new char8_t[textLength + 1];
	m_lineno = 1;
	m_base = offset;
	AdvanceCharPtr(static_cast<size_t>(offset));
}

// ANSI Binary chars are ...
// Note that this does include '-', and therefore whitespace is
// required to separate negation from a binary operator
bool Lexer::isAnsiBinaryChar(int ch)
{
	switch (ch)
	{
	case u8'!':
	case u8'%':
	case u8'&':
	case u8'*':
	case u8'+':
	case u8',':
	case u8'/':
	case u8'<':
	case u8'=':
	case u8'>':
	case u8'?':
	case u8'@':
	case u8'\\':
	case u8'~':
	case u8'|':
	case u8'-':
		return true;
	}
	return false;
}

bool Lexer::IsASingleBinaryChar(int ch) const
{
	// Returns true if (ch) is a single binary characater
	// that can't be continued.
	//
	switch (ch)
	{
	case u8'[':
	case u8'(':
	case u8'{':
	case u8'#':
		return true;
	}
	return false;
}

inline void Lexer::SkipBlanks()
{
	// Skips blanks in the input stream but emits syntax colouring for newlines
	int ch = m_cc;
	while (isspace(ch))
		ch = NextChar();
}

void Lexer::SkipComments()
{
	textpos_t commentStart = CharPosition;
	while (m_cc == COMMENTDELIM)
	{
		int ch;
		do
		{
			ch = NextChar();
			if (isEof(ch))
			{
				// Break out at EOF 
				CompileError(TEXTRANGE(commentStart, CharPosition), LErrCommentNotClosed);
				return;
			}
		} while (ch != COMMENTDELIM);

		NextChar();
		SkipBlanks();
	}
}

inline bool issign(int ch)
{
	return ch == u8'-' || ch == u8'+';
}

double Lexer::get_ThisTokenFloat() const
{
	_CRT_DOUBLE result;
	u8string str = ThisTokenText;
	int retval = _atodbl_l(&result, (LPSTR)str.c_str(), m_locale);
	if (retval != 0)
	{
		// Most likely overflow or underflow. _atodbl will have set an appropriate continuation value
		const_cast<Lexer*>(this)->CompileError((int)LErrBadNumber);
	}

	return result.x;
}

void Lexer::ScanFloat()
{
	int ch = NextChar();
	if (isdigit(PeekAtChar()))
	{
		m_tokenType = TokenType::FloatingConst;

		do
		{
			*m_tp++ = ch;
			ch = NextChar();
		} while (isdigit(ch));

		// Read the exponent, if any
		if (ch == u8'e' || ch == u8'd' || ch == u8'q')
		{
			int peek = PeekAtChar();
			if (isdigit(peek) || issign(peek))
			{
				if (issign(peek))
				{
					NextChar();
					if (!isdigit(PeekAtChar()))
					{
						PushBack(peek);
						PushBack(ch);
						return;
					}

					ch = peek;
				}
				else
					ch = NextChar();

				*m_tp++ = u8'e';

				do
				{
					*m_tp++ = ch;
					ch = NextChar();
				} while (isdigit(ch));
			}
		}
	}

	PushBack(ch);
}

int Lexer::DigitValue(int ch) const
{
	return ch >= u8'0' && ch <= u8'9'
		? ch - u8'0'
		: (ch >= u8'A' && ch <= u8'Z')
		? ch - u8'A' + 10
		: -1;
}

// Note that the first digit has already been placed in the token buffer
void Lexer::ScanInteger(radix_t radix)
{
	m_integer = 0;
	m_tokenType = TokenType::SmallIntegerConst;
	int digit = DigitValue(PeekAtChar());

	intptr_t maxval = INTPTR_MAX / static_cast<intptr_t>(radix);

	while (digit >= 0 && digit < static_cast<int>(radix))
	{
		*m_tp++ = NextChar();

		if (m_tokenType == TokenType::SmallIntegerConst)
		{
			if (m_integer < maxval || (m_integer == maxval && digit <= INT_MAX % static_cast<int>(radix)))
			{
				// we won't overflow, go ahead 
				m_integer = (m_integer * static_cast<int>(radix)) + digit;
			}
			else
				// It will have to be left to Smalltalk to calc the large integer value
				m_tokenType = TokenType::LargeIntegerConst;
		}

		digit = DigitValue(PeekAtChar());
	}
}

// Note that the first digit has already been placed in the token buffer
void Lexer::ScanExponentInteger()
{
	int e = NextChar();
	char8_t* mark = m_tp;
	*m_tp++ = e;

	int ch = PeekAtChar();
	if (ch == u8'-' || ch == u8'+')
	{
		*m_tp++ = NextChar();
		ch = PeekAtChar();
	}

	if (isdigit(ch))
	{
		do
		{
			*m_tp++ = NextChar();
		} while (isdigit(PeekAtChar()));
		m_tokenType = TokenType::LargeIntegerConst;
	}
	else
	{
		while (m_tp > mark)
		{
			m_tp--;
			PushBack(*m_tp);
		}
	}
}

void Lexer::ScanNumber()
{
	PushBack(*--m_tp);

	ScanInteger(radix_t::Decimal);

	int ch = PeekAtChar();

	// If they both read the same number of characters or the integer ended
	// in a radix specifier then we got ourselves an integer but we'll need
	// to check its in range later.
	//
	switch (ch)
	{
	case u8'r':
	{
		if (m_tokenType != TokenType::SmallIntegerConst)
			return;

		if (m_integer >= static_cast<int>(radix_t::Min) && m_integer <= static_cast<int>(radix_t::Max))
		{
			// Probably a short or long integer with a leading radix.

			*m_tp++ = NextChar();
			char8_t* startSuffix = m_tp;
			intptr_t radixCandidate = m_integer;
			radix_t radix = static_cast<radix_t>(radixCandidate);
			ScanInteger(radix);
			if (m_tp == startSuffix)
			{
				m_integer = radixCandidate;
				m_tp--;
				PushBack(ch);
			}
		}
	}
	break;

	case u8's':
		// A ScaledDecimal
		*m_tp++ = NextChar();

		// We must read over the trailing scale (optional)
		while (isdigit(PeekAtChar()))
			*m_tp++ = NextChar();

		m_tokenType = TokenType::ScaledDecimalConst;
		break;

	case u8'.':
		// Its probably a floating value but might actually
		// be the end of statement
		ScanFloat();

		if (PeekAtChar() == u8's')
		{
			// Its a scaled decimal - include any trailing digits
			*m_tp++ = NextChar();

			while (isdigit(PeekAtChar()))
				*m_tp++ = NextChar();

			m_tokenType = TokenType::ScaledDecimalConst;
		}
		break;

	case u8'e':
	{
		// Allow old St-80 exponent form, such as 1e6
		ScanExponentInteger();
		break;
	}

	default:
		break;
	};
}

// Read string up to terminating quote, ignoring embedded double quotes
Lexer::TokenType Lexer::ScanString(textpos_t stringStart)
{
	int ch;
	bool isAscii = true;
	do
	{
		ch = NextChar();
		if (!isEof(ch))
		{
			if (ch == STRINGDELIM)
			{
				// Possible termination or double quotes
				if (PeekAtChar() == STRINGDELIM)
					ch = NextChar();
				else
					break;
			}
			else if (ch > 127)
			{
				isAscii = false;
			}

			*m_tp++ = ch;
		}
		else
		{
			CompileError(TEXTRANGE(stringStart, CharPosition), LErrStringNotClosed);
		}
	} while (!isEof(ch));

	return isAscii ? TokenType::AsciiStringConst : TokenType::Utf8StringConst;
}

void Lexer::ScanName()
{
	while (isIdentifierSubsequent(NextChar()))
		*m_tp++ = m_cc;
	u8string name = ThisTokenText;
	if (name == u8"true"s)
		m_tokenType = TokenType::TrueConst;
	else if (name == u8"false"s)
		m_tokenType = TokenType::FalseConst;
	else if (name == u8"nil"s)
		m_tokenType = TokenType::NilConst;
}

void Lexer::ScanQualifiedName()
{
	LPUTF8 endLastWord = m_tp;
	*m_tp++ = m_cc;
	ScanName();
	if (m_tokenType != TokenType::NameConst)
	{
		m_tokenType = TokenType::NameConst;
	}
	else
	{
		if (m_cc == u8'.' && isLetter(PeekAtChar()))
			ScanQualifiedName();
		else
			PushBack(m_cc);
	}
}

void Lexer::ScanIdentifierOrKeyword()
{
	m_tokenType = TokenType::NameConst;
	ScanName();
	if (m_tokenType == TokenType::NameConst && m_cc == u8'.' && isLetter(PeekAtChar()))
		ScanQualifiedName();
	else
	{
		// It might be a Keyword terminated with a ':' (but not :=)
		// in which case we need to include it.
		if (m_cc == u8':' && PeekAtChar() != u8'=')
		{
			*m_tp++ = m_cc;
			m_tokenType = TokenType::NameColon;
		}
		else
		{
			PushBack(m_cc);
		}
	}
}

void Lexer::ScanSymbol()
{
	char8_t* lastColon = nullptr;
	while (isIdentifierFirst(m_cc))
	{
		*m_tp++ = m_cc;
		int ch = NextChar();
		while (isIdentifierSubsequent(ch))
		{
			*m_tp++ = ch;
			ch = NextChar();
		}
		if (ch == u8':')
		{
			lastColon = m_tp;
			*m_tp++ = ch;
			ch = NextChar();
		}
	}

	if (lastColon != nullptr && *(m_tp - 1) != u8':')
	{
		m_cp = m_cp - (m_tp - lastColon);
		m_tp = lastColon + 1;
		NextChar();
	}
	else
		PushBack(m_cc);
}

void Lexer::ScanBinary()
{
	while (isAnsiBinaryChar(m_cc))
	{
		*m_tp++ = m_cc;
		NextChar();
	}
	PushBack(m_cc);
}

void Lexer::ScanLiteral()
{
	// Literal; remove #
	m_tp--;
	NextChar();

	if (isIdentifierFirst(m_cc))
	{
		ScanSymbol();
		m_tokenType = TokenType::SymbolConst;
	}

	else if (isAnsiBinaryChar(m_cc))
	{
		ScanBinary();
		m_tokenType = TokenType::SymbolConst;
	}

	else if (m_cc == STRINGDELIM)
	{
		// Quoted Symbol
		ScanString(CharPosition);
		m_tokenType = TokenType::SymbolConst;
	}

	else if (m_cc == u8'(')
	{
		m_tokenType = TokenType::ArrayBegin;
	}

	else if (m_cc == u8'[')
	{
		m_tokenType = TokenType::ByteArrayBegin;
	}

	else if (m_cc == u8'{')
	{
		m_tokenType = TokenType::QualifiedRefBegin;
	}

	else if (m_cc == LITERAL)
	{
		// Second hash, so should be a constant expression ##(xxx)
		NextChar();
		if (m_cc != u8'(')
			CompileError(TEXTRANGE(CharPosition, CharPosition), LErrExpectExtendedLiteral);
		m_tokenType = TokenType::ExprConstBegin;
	}

	else
	{
		m_thisTokenRange.m_stop = CharPosition;
		CompileError(LErrExpectConst);
	}
}

Lexer::TokenType Lexer::NextToken()
{
	m_lastTokenRange = m_thisTokenRange;
	NextChar();

	// Skip blanks and comments
	SkipBlanks();
	SkipComments();

	// Start remembering this token
	textpos_t start = CharPosition;
	m_thisTokenRange.m_start = start;

	m_tp = m_token;
	int ch = m_cc;

	*m_tp++ = ch;

	if (!isEof(ch))
	{
		if (isIdentifierFirst(ch))
		{
			ScanIdentifierOrKeyword();
		}

		else if (isdigit(ch))
		{
			ScanNumber();
		}

		else if (ch == u8'-' && isdigit(PeekAtChar()))
		{
			Step();
			ScanNumber();
			if (m_tokenType == TokenType::SmallIntegerConst)
				m_integer *= -1;
		}
		else if (ch == LITERAL)
		{
			ScanLiteral();
		}

		else if (ch == STRINGDELIM)
		{
			textpos_t stringStart = CharPosition;
			// String constant; remove quote
			m_tp--;
			m_tokenType = ScanString(stringStart);
		}

		else if (ch == CHARLITERAL)
		{
			ScanLiteralCharacter();
		}

		else if (ch == u8'^')
		{
			m_tokenType = TokenType::Return;
		}

		else if (ch == u8':')
		{
			if (PeekAtChar() == u8'=')
			{
				m_tokenType = TokenType::Assignment;
				*m_tp++ = u8'=';
				NextChar();
			}
			else
				m_tokenType = TokenType::Special;
		}

		else if (ch == u8')')
		{
			m_tokenType = TokenType::CloseParen;
		}

		else if (ch == u8'.')
		{
			m_tokenType = TokenType::CloseStatement;
		}

		else if (ch == u8']')
		{
			m_tokenType = TokenType::CloseSquare;
		}

		else if (ch == u8'}')
		{
			m_tokenType = TokenType::CloseBrace;
		}

		else if (ch == u8';')
		{
			m_tokenType = TokenType::Cascade;
		}

		else if (IsASingleBinaryChar(ch))
		{
			// Single binary expressions
			m_tokenType = TokenType::Binary;
		}

		else if (isAnsiBinaryChar(ch))
		{
			m_tokenType = TokenType::Binary;
		}
		else
		{
			textpos_t pos = CharPosition;
			int32_t cp = DecodeUtf8(ch);
			CompileError(TEXTRANGE(pos, pos), LErrBadChar, (Oop)m_piVM->NewCharacter(cp < 0 ? 0xFFFD : cp));
		}
	}
	else
	{
		// Hit EOF straightaway - so be careful not to write another Null term into the token
		// as this would involve writing off the end of the token buffer
		m_tokenType = TokenType::Eof;
		m_thisTokenRange.m_stop = start;
		m_thisTokenRange.m_start = start + 1;
	}

	m_thisTokenRange.m_stop = CharPosition;
	return m_tokenType;
}

int32_t Lexer::DecodeUtf8()
{
	int ch = Step();
	return ch < 0 ? EOF : DecodeUtf8(ch);
}

int32_t Lexer::DecodeUtf8(char8_t ch)
{
	if (ch <= 0x7f)
	{
		return ch;
	}
	else
	{
		uint32_t codePoint = -2;

		if (ch >= 0xc0)
		{
			int ch2 = Step();
			if ((ch2 & 0xC0) != 0x80)
			{
				return -3;
			}
			codePoint = (ch & 0x1F) << 6 | (ch2 & 0x3F);

			if (ch >= 0xE0)
			{
				int ch3 = Step();
				if ((ch3 & 0xC0) != 0x80)
				{
					return -4;
				}
				codePoint = (codePoint & 0x3FF) << 6 | (ch3 & 0x3F);

				if (ch >= 0xF0)
				{
					int ch4 = Step();
					if ((ch4 & 0xC0) != 0x80)
					{
						return -5;
					}
					codePoint = (codePoint & 0x7FFF) << 6 | (ch4 & 0x3F);
				}
			}
		}
		return codePoint;
	}
}

void Lexer::ScanLiteralCharacter()
{
	m_tokenType = TokenType::CharConst;
	m_integer = 0;

	// This is one of the few places we need to be aware of UTF-8 encoding. Generally the only chars that are significant to the compiler are
	// ascii. This would change if we decided to allow multi-lingual characters in identifiers, for example. But at present we parse only
	// the ANSI X3J20 lexicon, which only recognises English letters, digits, and some ascii symbols and whitespace characters. That doesn't
	// prevent the compiler successfully reading multi-lingual characters in literal strings, as they are opaque to the compiler.
	int32_t codePoint = DecodeUtf8();

	if (codePoint == EOF)
	{
		// Reached EOF
		textpos_t pos = CharPosition;
		m_thisTokenRange.m_stop = pos;
		CompileError(LErrExpectChar);
		return;
	}
	else if(codePoint == u8'\\')
	{
		// Dolphin supports an extended C-style escaped character syntax (used in many languages)
		switch (PeekAtChar())
		{
		case u8'0':
			Step();
			m_integer = u8'\0';
			return;
		case u8'a':
			Step();
			m_integer = u8'\a';
			return;
		case u8'b':
			Step();
			m_integer = u8'\b';
			return;
		case u8'f':
			Step();
			m_integer = u8'\f';
			return;
		case u8'n':
			Step();
			m_integer = u8'\n';
			return;
		case u8'r':
			Step();
			m_integer = u8'\r';
			return;
		case u8't':
			Step();
			m_integer = u8'\t';
			return;
		case u8'v':
			Step();
			m_integer = u8'\v';
			return;
		case u8'x':
			Step();
			codePoint = ReadHexCodePoint();
			if (codePoint < 0)
			{
				textpos_t pos = CharPosition;
				m_thisTokenRange.m_stop = pos;
				CompileError(LErrExpectCodePoint);
				return;
			}
			break;
		default:
			break;
		}
	}

	if (static_cast<char32_t>(codePoint) > MaxCodePoint || U_IS_UNICODE_NONCHAR(codePoint))
	{
		textpos_t pos = CharPosition;
		m_thisTokenRange.m_stop = pos;
		CompileError(LErrBadCodePoint);
	}
	else
	{
		m_integer = codePoint;
	}
}

inline int32_t Lexer::ReadHexCodePoint()
{
	int digit = DigitValue(PeekAtChar());
	if (digit < 0 || digit >= 16)
	{
		Step();
		return -1;
	}

	int32_t codePoint = 0;

	do
	{
		Step();
		
		// Avoid potential overflow for long hex sequence 
		if (codePoint <= MaxCodePoint)
		{
			codePoint = (codePoint * 16) + digit;
		}

		digit = DigitValue(PeekAtChar());
	} 
	while (digit >= 0 && digit < 16);

	return codePoint;
}
