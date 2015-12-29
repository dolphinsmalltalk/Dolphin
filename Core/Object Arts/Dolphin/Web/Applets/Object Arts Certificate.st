"DolphinSure certificate RE108002 for Object Arts Ltd."

"Evaluate the following expressions in a workspace"

"Recreate the certificate from it's bytes"
certificate := Object fromBinaryStoreBytes: #[33 83 84 66 32 48 32 6 4 22 0 68 111 108 112 104 105 110 83 117 114 101 67 101 114 116 105 102 105 99 97 116 101 0 0 0 0 54 0 9 0 66 121 116 101 65 114 114 97 121 231 0 0 0 33 83 84 66 32 48 32 6 6 26 0 68 111 108 112 104 105 110 83 117 114 101 67 101 114 116 105 102 105 99 97 116 101 73 110 102 111 0 0 0 0 54 0 6 0 83 116 114 105 110 103 8 0 0 0 82 69 49 48 56 48 48 50 114 0 0 0 16 0 0 0 79 98 106 101 99 116 32 65 114 116 115 32 76 116 100 46 114 0 0 0 0 0 0 0 6 1 4 0 68 97 116 101 0 0 0 0 159 26 1 0 0 0 0 0 54 0 12 0 76 97 114 103 101 73 110 116 101 103 101 114 96 0 0 0 209 227 214 10 255 11 81 254 188 74 16 246 149 205 116 56 197 87 121 130 13 123 60 24 70 64 134 25 176 118 61 28 18 112 191 212 25 114 123 127 117 33 101 76 141 6 227 97 25 198 127 20 251 199 178 75 126 226 211 32 144 75 106 250 82 97 141 9 139 196 59 236 168 124 136 119 168 247 219 211 202 118 232 234 47 187 65 16 252 88 219 93 22 206 129 71 54 0 6 0 83 116 114 105 110 103 22 0 0 0 68 111 108 112 104 105 110 83 117 114 101 67 101 114 116 105 102 105 99 97 116 101 146 0 0 0 105 0 0 0 91 68 83 65 32 100 105 103 105 116 97 108 32 115 105 103 110 97 116 117 114 101 32 51 55 56 51 49 52 53 65 50 57 68 53 52 56 68 69 49 68 57 68 65 65 49 52 49 69 54 50 51 50 55 51 68 54 65 67 51 68 51 54 32 53 54 68 50 51 69 66 66 53 50 70 51 57 49 51 68 52 55 69 53 54 66 50 67 70 69 48 51 70 70 56 70 66 55 49 52 49 51 49 49 93 0 0 0 0 ].

"Show the certificate"
certificate show.

"Add it to your personal store"
DolphinSureCertificateStore myCertificates addCertificate: certificate.

"Retrieve it from your personal store"
(DolphinSureCertificateStore myCertificates atSerial: 'RE108002' ifAbsent: []) show.

"If it is your default (first) certificate you can retrieve it like this..."
DolphinSureCertificateStore myCertificates default show.

"THIS IS YOUR PRIVATE KEY=971553653994046386128003800500391115595036543107 (DO NOT DISCLOSE)"

"Sign data with your certificate"
trustedData := certificate sign: 'This is a secure message' asByteArray privateKey: 971553653994046386128003800500391115595036543107.
trustedData validData asString "Display it".
trustedData data at: 1 put: 0 "Change the data".
trustedData validData asString "Now try to Display it".


"If you have the Web Deployment Kit you can sign  binary class files with your certificate"