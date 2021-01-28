"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTest subclass: #'Security.Tests.DolphinSureTrustedDataTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Security.Tests.DolphinSureTrustedDataTest guid: (Core.GUID fromString: '{2ed3ecdf-4736-4144-87cc-6b51d3857654}')!
Security.Tests.DolphinSureTrustedDataTest comment: ''!
!Security.Tests.DolphinSureTrustedDataTest categoriesForClass!Unclassified! !
!Security.Tests.DolphinSureTrustedDataTest methodsFor!

testBinaryReadOldCertificate
	| oaCert oaCert2 oldBytes |
	"Bytes copied from the ObjectArtsCertificate class>>new method before namespace changes"
	oldBytes := #[33 83 84 66 32 51 32 6 4 22 0 68 111 108 112 104 105 110 83 117 114 101 67 101 114 116 105 102 105 99 97 116 101 114 0 0 0 204 0 0 0 33 83 84 66 32 51 32 6 6 26 0 68 111 108 112 104 105 110 83 117 114 101 67 101 114 116 105 102 105 99 97 116 101 73 110 102 111 82 0 0 0 8 0 0 0 82 69 49 48 56 48 48 51 82 0 0 0 15 0 0 0 79 98 106 101 99 116 32 65 114 116 115 32 76 116 100 82 0 0 0 0 0 0 0 6 1 4 0 68 97 116 101 113 43 1 0 0 0 0 0 130 0 0 0 96 0 0 0 194 198 186 38 2 246 29 161 133 146 190 194 191 75 81 196 208 66 109 156 133 94 234 249 104 184 7 126 214 141 94 178 172 231 11 65 67 9 146 131 144 23 135 176 38 228 169 95 140 79 88 167 59 154 52 76 93 191 243 93 240 20 67 134 165 189 253 195 247 177 187 53 138 106 180 158 120 232 242 204 63 13 120 139 60 13 5 22 9 130 51 166 101 180 227 10 82 0 0 0 22 0 0 0 68 111 108 112 104 105 110 83 117 114 101 67 101 114 116 105 102 105 99 97 116 101 82 0 0 0 105 0 0 0 91 68 83 65 32 100 105 103 105 116 97 108 32 115 105 103 110 97 116 117 114 101 32 53 65 69 70 69 54 70 68 67 55 55 50 67 48 69 65 65 57 70 70 69 49 70 68 56 55 65 66 67 53 54 67 56 52 53 67 65 56 51 50 32 56 55 69 69 67 69 68 54 54 51 52 66 53 67 52 69 48 49 54 48 48 66 68 65 67 53 50 57 65 67 67 69 50 54 69 66 51 70 65 52 93 0 0 0 0].
	oaCert := DolphinSureTrustedData fromBinaryStoreBytes: oldBytes.
	oaCert2 := ObjectArtsCertificate new.
	self assert: oaCert equals: oaCert2.
	self assert: oaCert serial equals: oaCert2 serial.
	self assert: oaCert owner equals: oaCert2 owner.
	self assert: oaCert info expiry equals: oaCert2 info expiry.
	"When the cert is re-serialised, full class names will be written, so the store bytes will be different"
	self deny: oaCert binaryStoreBytes equals: oldBytes.
	oaCert2 := ObjectArtsCertificate new.
	self deny: oaCert data equals: oaCert2 data.
	self assert: oaCert info binaryStoreBytes equals: oaCert2 data.
! !
!Security.Tests.DolphinSureTrustedDataTest categoriesFor: #testBinaryReadOldCertificate!private! !

