﻿"Filed out from Dolphin Smalltalk"!

Core.Object subclass: #'UI.Examples.Ball'
	instanceVariableNames: 'position velocity icon'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Examples.Ball guid: (Core.GUID fromString: '{09652d38-e87c-4cb5-b5fd-2d093fae268b}')!
UI.Examples.Ball comment: ''!
!UI.Examples.Ball categoriesForClass!Unclassified! !
!UI.Examples.Ball methodsFor!

drawOn: aCanvas 
	self icon drawOn: aCanvas
		at: (self position - (self icon extent / 2)) truncated!

icon
	^icon isNil ifTrue: [self class icon] ifFalse: [icon]!

icon: anObject 
	icon := anObject!

position
	^position!

position: anObject 
	position := anObject!

velocity
	^velocity!

velocity: anObject 
	velocity := anObject! !
!UI.Examples.Ball categoriesForMethods!
drawOn:!drawing!public! !
icon!accessing!public! !
icon:!accessing!private! !
position!accessing!public! !
position:!accessing!private! !
velocity!accessing!public! !
velocity:!accessing!private! !
!

!UI.Examples.Ball class methodsFor!

blueIcon
	^InternalIcon fromBytes: #[137 80 78 71 13 10 26 10 0 0 0 13 73 72 68 82 0 0 0 48 0 0 0 48 8 6 0 0 0 87 2 249 135 0 0 0 1 115 82 71 66 0 174 206 28 233 0 0 0 4 103 65 77 65 0 0 177 143 11 252 97 5 0 0 0 9 112 72 89 115 0 0 14 195 0 0 14 195 1 199 111 168 100 0 0 9 104 73 68 65 84 104 67 237 152 123 112 205 103 26 199 159 223 239 220 114 17 137 180 196 201 85 194 57 130 36 34 34 17 18 34 41 178 18 119 137 75 46 164 132 166 137 32 228 162 228 34 17 36 66 8 105 66 46 40 18 74 92 66 20 211 181 117 233 148 221 69 171 219 221 210 213 53 89 101 218 93 165 104 107 76 219 239 62 239 57 137 181 45 90 114 248 99 39 153 121 231 204 100 206 249 253 222 207 251 124 159 231 251 60 47 81 219 95 219 9 180 157 64 219 9 180 157 64 219 9 152 234 4 194 102 107 104 76 70 32 69 229 46 164 152 162 50 154 190 190 142 18 171 235 104 246 182 50 154 191 59 155 50 14 4 83 78 131 133 169 94 103 186 231 4 78 233 75 33 51 54 211 136 148 239 105 236 66 208 196 60 80 236 74 208 244 117 160 196 42 80 202 54 208 252 93 160 204 3 160 172 163 247 105 201 137 253 84 112 122 136 233 54 240 172 79 242 10 114 37 223 145 135 41 104 242 79 244 74 2 40 124 14 104 108 38 3 44 1 197 20 130 226 215 130 102 109 128 148 188 5 82 234 78 200 153 251 33 103 29 133 156 119 28 242 242 51 144 86 158 59 67 171 63 242 121 214 215 183 238 119 58 191 89 228 25 114 155 252 198 128 130 162 97 0 24 145 2 26 147 14 138 204 1 69 47 135 52 173 4 210 204 114 200 73 155 160 152 183 3 202 204 125 80 103 31 129 58 255 56 212 43 78 67 189 234 60 20 37 159 220 151 75 47 229 16 65 106 221 134 126 251 175 37 114 233 189 132 186 7 128 188 94 1 245 27 13 10 156 2 10 157 14 10 75 2 141 90 0 154 176 24 210 228 165 144 226 138 161 72 40 131 50 169 6 170 212 90 104 50 247 194 114 201 81 180 47 124 31 214 171 207 162 125 233 199 104 87 118 17 102 229 151 161 40 187 178 157 114 254 160 252 237 219 120 214 111 58 184 23 82 151 222 32 125 11 192 40 208 192 73 160 33 211 64 195 19 65 17 243 64 227 222 128 60 41 15 138 184 149 80 37 172 135 58 169 26 230 243 107 97 181 168 1 182 5 191 135 221 234 51 232 92 118 1 118 21 159 162 99 213 231 176 173 105 130 101 101 19 228 138 166 221 207 55 18 90 253 104 114 234 245 35 185 122 131 186 15 48 70 192 119 36 104 64 36 104 112 28 104 232 76 131 140 164 177 25 80 76 204 133 50 182 16 234 25 165 48 79 170 132 213 130 58 216 102 53 160 211 242 99 112 42 253 19 186 85 95 68 215 45 87 224 186 253 11 56 215 126 9 187 109 95 161 221 166 235 144 55 92 93 244 172 103 251 228 223 117 114 181 35 251 238 183 200 177 7 30 0 120 134 128 124 70 128 250 143 51 230 65 179 140 228 209 11 160 136 204 130 58 102 57 204 103 172 69 187 228 74 216 44 168 69 199 236 6 56 22 189 7 93 197 135 232 93 123 5 222 187 191 132 215 158 27 232 177 231 38 186 214 127 131 206 59 190 134 121 245 245 31 168 226 106 128 233 33 180 186 213 100 175 7 57 186 27 1 244 253 65 189 6 131 188 135 131 252 56 15 90 100 52 44 17 138 81 169 80 71 46 134 121 236 50 88 38 172 129 117 242 70 188 148 94 11 199 188 70 232 214 156 130 87 205 95 224 191 235 42 2 27 111 193 191 241 54 124 14 222 133 231 193 239 224 182 231 14 108 183 254 11 170 170 107 167 76 11 224 212 221 158 180 250 123 6 0 103 15 144 91 95 35 128 123 96 179 140 34 64 1 44 163 65 177 144 134 38 64 25 49 7 154 9 11 97 17 147 15 171 233 171 96 147 84 142 142 105 91 225 156 119 0 250 146 19 232 93 117 1 1 111 55 33 248 208 45 4 190 115 7 254 135 190 69 159 198 239 224 190 255 46 236 235 110 192 162 250 26 168 162 41 204 116 16 90 93 138 97 243 14 221 141 0 34 137 221 124 140 16 30 193 160 62 191 3 249 143 229 106 52 25 82 200 171 80 142 72 134 102 92 58 44 38 231 194 42 190 8 54 137 235 209 49 117 19 156 114 246 66 95 124 12 222 27 207 33 96 199 231 8 105 252 26 193 135 239 96 192 59 119 225 219 200 81 104 184 139 46 187 110 162 195 150 235 80 110 104 170 55 29 128 189 238 228 3 0 145 3 78 189 64 46 94 160 110 253 64 61 130 64 189 135 114 57 229 106 52 32 10 114 240 84 40 195 18 161 25 157 10 139 137 139 97 53 117 25 108 102 174 65 199 185 85 112 90 188 11 221 139 142 194 187 252 143 8 216 126 9 161 7 190 66 232 225 219 44 165 111 224 219 112 11 30 123 111 194 237 237 27 232 80 253 79 40 203 46 127 79 155 254 97 214 122 136 151 221 181 188 249 31 141 0 172 127 199 158 70 0 17 137 174 190 12 240 144 140 250 143 135 60 40 26 170 97 9 48 27 57 7 150 145 11 209 158 101 100 51 189 24 47 39 151 195 49 115 59 116 5 141 240 90 119 10 254 155 63 70 208 174 43 8 218 123 29 253 118 95 131 231 142 171 208 215 94 133 203 214 47 96 179 225 50 212 101 159 129 214 253 45 184 245 0 246 221 34 12 155 111 145 144 1 130 151 128 232 202 185 224 62 16 236 200 70 25 177 169 201 129 19 161 10 141 135 89 120 18 44 199 165 161 221 164 44 180 143 91 134 14 28 5 237 252 26 184 229 212 163 71 241 187 232 93 246 1 250 214 92 64 191 109 151 224 185 249 34 244 53 23 225 90 253 25 28 170 254 14 155 55 63 133 166 244 175 160 213 159 188 214 122 0 109 183 57 15 0 90 64 196 167 19 71 194 173 143 49 15 122 14 50 202 168 111 56 228 128 241 80 5 199 66 51 124 38 71 33 5 22 227 51 96 57 57 7 237 227 11 209 73 68 33 99 43 92 115 247 64 183 226 8 122 172 61 5 143 138 179 208 151 159 135 235 155 231 225 80 246 33 58 173 191 0 235 181 31 65 85 124 30 82 241 133 21 173 7 176 215 149 60 18 64 228 66 23 46 167 221 252 140 213 200 99 136 161 164 74 92 82 21 28 5 101 200 52 168 195 94 131 102 212 92 152 115 69 178 140 206 131 53 87 36 33 165 206 105 111 193 41 187 30 110 203 15 163 219 170 227 112 89 117 18 218 149 39 241 82 209 41 216 172 252 0 22 69 167 161 88 126 26 82 225 217 146 231 7 32 34 32 252 64 39 0 88 70 194 19 60 67 33 245 29 1 69 192 56 40 7 71 67 61 116 58 52 44 37 205 152 249 48 143 92 4 171 184 2 131 148 58 205 169 132 125 198 118 56 100 213 195 33 239 32 236 150 28 66 135 220 67 104 191 228 8 44 243 143 65 147 255 30 20 249 39 65 249 239 103 154 2 192 104 96 63 95 2 64 148 83 145 7 58 127 134 224 214 130 165 36 121 15 133 194 111 20 148 3 163 160 26 18 103 72 104 85 120 50 212 99 22 112 89 205 129 53 75 169 195 172 82 216 38 111 128 237 188 205 108 112 117 176 78 223 9 203 140 221 48 95 184 15 154 69 7 161 228 142 85 202 126 23 148 123 44 163 245 0 90 221 236 71 75 136 19 249 97 79 16 145 224 14 85 98 41 201 62 97 144 185 205 22 9 173 96 8 5 247 72 202 240 217 236 13 25 48 155 152 13 243 152 2 152 199 23 195 98 230 58 88 38 109 132 121 202 38 104 230 110 229 142 181 14 202 180 122 40 50 27 64 111 28 2 45 62 18 211 122 128 206 250 126 143 7 224 74 212 133 253 64 36 179 136 132 240 5 150 147 196 85 73 226 30 73 98 115 147 217 220 100 238 84 229 97 179 160 8 79 129 114 76 26 212 81 89 208 68 23 192 108 90 49 204 18 74 161 158 85 14 101 98 37 20 201 155 33 207 173 133 36 166 183 244 125 160 140 125 125 90 15 224 226 98 70 246 186 111 127 1 209 82 74 93 216 15 132 169 9 57 137 164 230 72 72 66 74 92 149 36 223 8 72 92 149 164 160 41 236 208 241 80 112 187 173 140 152 11 21 71 66 21 149 13 213 148 165 80 197 21 65 17 95 2 121 198 122 72 98 122 227 225 135 82 182 131 230 237 184 71 51 255 172 106 61 128 120 130 189 126 195 35 163 32 90 11 195 18 222 208 236 208 174 125 32 113 105 149 56 169 37 239 97 144 216 161 37 238 147 164 65 49 144 185 91 149 217 165 101 134 144 121 114 147 121 240 17 115 131 20 179 2 210 212 85 144 196 12 205 16 244 122 13 104 246 91 251 77 179 121 241 20 109 87 31 6 248 233 145 16 63 79 110 131 67 11 131 227 164 22 165 85 24 156 24 59 185 205 32 134 16 189 146 196 145 144 120 126 150 70 167 67 18 211 155 184 4 224 17 148 226 86 129 94 101 136 132 114 94 21 225 166 3 48 68 65 87 245 84 0 98 224 105 246 6 97 112 15 32 6 115 199 202 145 104 129 32 134 160 241 139 64 81 124 17 48 101 25 67 20 131 166 174 62 71 57 57 178 105 1 28 123 218 146 86 119 237 87 33 156 57 177 13 157 42 151 86 209 39 9 8 225 210 98 240 121 16 137 88 227 240 35 70 208 240 185 60 71 167 25 198 80 190 79 2 77 202 255 129 162 151 62 167 155 10 123 125 232 175 74 73 228 130 72 106 1 97 240 7 1 193 45 183 24 63 255 7 34 198 8 193 3 144 225 54 99 100 42 223 104 240 149 204 216 12 19 212 254 39 197 78 171 203 125 98 20 68 117 114 241 52 2 136 178 42 122 37 33 39 209 118 179 83 183 52 125 134 57 154 115 130 134 196 243 149 12 207 210 195 95 103 144 228 197 166 149 205 163 159 38 49 192 186 199 66 136 170 36 92 218 153 33 132 71 112 85 50 194 52 247 76 15 117 174 20 48 193 56 138 26 64 166 189 144 205 183 32 9 136 36 78 236 219 143 53 57 3 132 240 8 6 17 171 217 35 254 155 23 195 140 146 242 9 191 207 109 248 115 150 205 227 226 170 117 115 102 128 218 95 230 69 139 63 60 244 217 210 252 137 72 136 75 49 33 43 247 192 19 228 30 244 156 18 246 105 196 232 168 243 227 10 181 147 215 191 31 43 45 145 220 34 34 78 30 247 88 94 59 88 94 254 79 243 138 23 245 93 137 28 244 94 12 194 151 0 186 53 124 147 81 103 88 246 186 74 210 186 39 243 255 131 200 206 203 242 69 109 166 237 61 109 39 208 118 2 109 39 208 118 2 255 255 39 240 31 190 154 94 180 253 124 181 205 0 0 0 0 73 69 78 68 174 66 96 130]!

greenIcon
	^##((TextTileIcon text: $\x1F30D fontName: 'Segoe UI Emoji')
		textcolor: Color darkGreen;
		yourself)!

icon
	^##(TextTileIcon text: $\x1F3B1 fontName: 'Segoe UI Emoji')!

redIcon
	^##((TextTileIcon text: $\x1F3B1 fontName: 'Segoe UI Emoji')
		textcolor: Color crimson;
		yourself)!

yellowIcon

	^InternalIcon fromBytes: #[137 80 78 71 13 10 26 10 0 0 0 13 73 72 68 82 0 0 0 48 0 0 0 48 8 6 0 0 0 87 2 249 135 0 0 0 1 115 82 71 66 0 174 206 28 233 0 0 0 4 103 65 77 65 0 0 177 143 11 252 97 5 0 0 0 9 112 72 89 115 0 0 14 195 0 0 14 195 1 199 111 168 100 0 0 9 172 73 68 65 84 104 67 237 88 119 80 85 119 22 142 59 187 179 153 221 255 54 10 98 77 76 4 68 69 120 143 222 123 147 46 189 43 93 105 34 8 161 248 232 66 80 64 69 5 69 1 3 65 172 1 98 55 194 136 174 16 187 81 52 209 197 18 113 215 74 52 138 72 224 125 123 206 101 153 117 28 75 34 79 255 200 224 204 157 59 190 225 221 119 190 115 190 114 126 247 131 15 70 254 141 116 96 164 3 35 29 24 233 192 72 7 100 212 129 21 209 54 127 45 79 181 48 248 42 207 250 243 166 98 135 213 45 235 92 235 142 87 123 214 157 223 234 183 250 74 99 224 146 187 7 130 77 186 26 195 254 38 163 159 147 221 99 22 249 136 196 153 225 218 85 197 241 134 79 55 44 177 64 253 82 91 124 83 226 136 230 114 87 180 87 123 226 251 122 95 116 54 6 225 63 251 67 240 176 37 162 239 89 123 84 131 244 244 66 83 217 85 240 150 79 114 179 84 252 36 216 89 101 111 162 191 88 154 29 169 139 146 69 70 168 72 55 71 93 158 13 26 138 28 112 112 141 11 254 89 233 129 51 117 62 248 113 103 32 186 246 134 160 187 37 2 189 109 209 144 158 89 8 105 199 162 118 233 229 68 209 91 254 252 240 190 102 169 51 49 220 195 114 234 163 136 57 51 177 56 64 12 6 80 20 111 132 242 84 51 212 100 91 99 199 50 123 236 43 117 70 235 6 119 156 172 245 193 165 29 129 248 105 119 8 238 55 71 162 231 88 12 6 78 199 3 29 139 33 189 146 220 39 189 150 34 1 62 24 53 188 138 126 251 183 71 25 170 143 207 156 109 240 9 188 173 149 16 238 58 19 9 254 34 100 132 235 160 48 206 0 107 146 77 81 157 105 133 173 5 118 216 181 210 9 45 235 220 112 252 75 31 92 216 22 136 107 187 66 113 191 37 10 125 199 19 128 239 147 129 31 211 128 107 75 128 46 9 164 183 210 107 1 201 159 127 123 25 111 249 151 26 202 114 5 70 234 227 97 167 255 49 188 172 21 17 230 50 3 241 190 34 164 135 104 33 63 90 31 171 22 155 128 117 176 121 169 29 154 74 156 112 168 220 29 237 155 124 112 126 91 16 174 239 137 68 119 235 66 244 159 78 1 46 81 211 59 179 128 155 57 192 237 92 224 78 22 164 119 36 219 222 233 36 196 138 114 78 58 51 199 14 24 139 39 192 222 112 112 2 33 206 211 17 235 173 134 148 185 154 200 153 175 135 98 210 193 186 84 115 212 230 218 226 235 34 71 28 88 235 134 99 213 190 4 32 24 215 247 46 192 131 214 69 232 63 155 14 92 205 167 206 23 2 119 139 128 110 186 30 46 3 30 228 65 122 47 35 245 45 123 251 250 175 105 207 144 147 23 79 147 251 89 107 250 88 48 0 166 16 105 0 65 14 42 88 224 49 75 208 193 32 141 12 137 70 102 168 206 178 198 246 66 71 236 91 227 142 163 85 126 56 187 53 24 87 247 68 161 251 104 18 164 23 168 235 93 37 84 240 26 224 209 90 224 9 221 123 87 211 189 24 210 7 57 253 210 251 233 186 50 7 33 82 26 83 36 82 150 131 230 116 121 24 139 198 195 86 239 99 184 154 125 6 63 59 101 132 147 144 153 70 105 68 163 165 2 141 76 81 153 97 131 173 133 78 216 179 218 3 173 149 126 56 179 37 20 215 247 197 225 81 59 117 255 135 47 136 54 84 244 147 74 224 233 70 160 111 3 208 95 65 119 6 84 72 32 178 142 200 20 128 186 210 71 227 68 202 99 122 25 128 174 170 2 204 52 39 194 134 0 56 24 77 17 116 16 236 52 29 49 94 106 72 158 171 33 184 81 113 130 9 214 167 91 163 46 223 17 77 43 221 208 92 225 139 147 155 67 208 185 39 14 221 199 210 48 208 81 0 220 162 98 31 87 81 231 233 234 35 32 191 18 136 190 114 250 172 24 184 159 3 233 125 137 141 204 64 136 148 228 99 184 120 141 105 242 208 35 0 70 52 1 51 141 137 194 20 220 204 167 34 208 126 26 230 187 169 10 110 36 9 99 26 25 97 109 138 37 190 204 177 199 206 162 57 216 95 230 141 182 154 121 248 161 41 6 119 90 83 208 119 110 41 112 163 148 186 205 0 54 1 207 232 254 140 1 172 3 122 86 17 181 242 73 208 25 219 101 6 64 93 73 174 149 1 136 9 0 107 64 119 166 2 12 212 198 193 82 123 18 156 76 62 133 143 141 18 66 201 141 98 189 213 145 58 79 11 121 81 134 88 185 216 28 27 51 236 176 165 208 5 187 75 61 209 90 21 132 243 59 163 208 213 156 140 158 83 228 58 157 43 168 80 162 79 15 1 232 161 9 60 33 10 61 41 3 126 89 73 142 148 11 105 87 218 83 92 149 124 56 108 16 34 229 209 10 84 252 128 48 1 21 2 48 99 44 116 8 128 158 234 56 88 104 77 130 163 241 20 193 141 152 70 81 44 230 64 13 100 69 234 163 104 145 25 202 211 109 80 187 212 9 95 151 184 227 219 245 126 56 185 37 2 157 251 18 208 221 150 137 129 75 203 73 200 36 224 123 235 201 137 136 78 183 185 112 162 207 93 114 163 155 100 175 55 40 35 174 38 153 200 2 128 61 23 63 68 33 77 2 193 66 230 41 152 107 77 20 116 224 97 169 40 208 40 140 66 109 33 103 66 168 46 242 99 141 81 154 108 133 202 76 123 212 127 225 130 111 104 10 71 55 5 227 66 99 44 186 90 82 240 203 137 108 12 92 36 27 189 74 110 212 73 69 119 146 46 174 145 181 222 200 163 207 40 35 254 149 194 41 29 49 124 0 74 163 99 135 0 12 221 197 4 72 155 38 97 162 49 65 208 129 139 233 32 141 230 58 210 20 60 213 144 20 164 133 172 249 6 88 22 111 138 181 169 214 168 206 182 199 246 229 174 56 184 222 31 223 213 133 227 98 83 44 110 30 74 194 207 109 75 240 235 185 92 12 156 207 38 107 165 174 119 80 225 151 40 153 47 165 146 208 19 129 139 9 249 195 6 160 174 52 166 248 69 0 252 127 214 2 139 217 74 103 50 28 105 10 238 22 83 5 75 229 41 196 249 136 145 18 172 131 92 210 66 113 2 83 201 26 53 121 14 104 88 193 84 98 16 161 184 216 24 141 159 190 77 196 131 163 169 120 212 150 130 199 109 73 120 250 93 34 250 79 46 166 164 78 192 179 211 180 236 157 143 47 126 103 0 120 2 28 104 214 186 147 5 26 113 38 120 90 41 10 193 54 223 67 13 9 1 154 144 132 235 161 128 168 180 42 201 2 21 18 27 108 46 112 198 174 82 47 28 174 12 194 169 45 52 137 134 40 92 163 108 184 121 32 22 183 14 70 227 110 115 52 30 30 137 193 99 90 246 122 218 99 208 123 34 38 121 216 0 134 2 236 197 41 208 74 33 76 128 117 96 163 55 89 88 45 6 169 164 76 142 52 147 28 73 68 185 160 141 76 18 116 97 28 235 193 130 168 52 155 168 52 7 123 214 120 161 101 131 63 218 107 230 226 220 182 80 116 236 8 197 229 134 16 92 223 29 134 127 239 15 23 54 214 238 195 145 4 100 65 210 176 1 16 133 162 95 70 33 22 51 135 154 144 9 20 108 76 37 94 47 220 136 74 1 179 85 40 157 85 137 74 34 164 144 173 102 71 234 97 249 66 99 148 165 90 210 138 97 135 250 2 71 52 150 184 226 64 153 39 142 84 250 226 120 141 63 206 214 7 224 226 246 32 116 54 205 195 77 58 55 220 62 24 134 7 205 97 126 195 6 160 166 248 145 230 235 0 208 106 13 83 18 51 79 130 115 97 200 149 152 74 145 20 110 241 126 98 164 5 107 35 119 1 89 107 188 49 5 156 5 170 50 109 9 132 3 129 112 161 101 207 29 135 43 60 113 172 202 11 167 106 125 209 177 205 31 87 26 130 232 236 64 64 14 204 83 31 54 0 227 201 147 63 164 41 60 121 17 4 79 64 200 131 89 227 132 80 99 32 188 35 89 145 38 156 41 220 188 201 149 132 108 32 87 74 12 208 192 146 80 109 218 147 12 80 146 96 138 242 52 158 4 131 176 71 99 177 19 246 150 186 208 218 61 71 56 189 157 170 245 198 133 173 126 184 188 35 160 23 39 194 254 50 108 0 252 0 117 37 249 242 151 89 41 39 51 175 23 12 134 93 137 117 97 66 194 182 165 179 2 139 218 215 86 25 33 148 208 188 39 37 81 192 241 182 154 47 128 48 65 89 138 57 77 194 74 56 55 236 92 110 143 221 116 248 57 84 230 42 128 56 81 227 133 115 155 125 26 100 82 60 63 132 210 88 68 0 164 47 163 210 243 159 113 62 240 174 196 116 98 81 179 181 6 80 192 241 177 51 142 214 140 228 32 13 218 149 120 18 250 116 126 38 77 164 152 9 32 234 242 108 133 35 232 16 136 214 13 110 56 90 225 54 91 102 0 4 16 74 99 42 222 4 224 249 109 117 8 0 103 195 60 162 82 132 27 231 195 32 136 255 79 194 24 229 12 34 195 82 120 17 176 163 112 54 118 173 112 36 74 57 159 130 68 242 39 153 2 208 81 153 240 15 90 234 110 189 9 4 59 147 41 109 170 188 110 243 158 196 174 36 164 244 255 68 61 4 34 147 232 84 64 147 88 145 64 194 254 220 12 27 37 22 168 205 177 70 125 190 109 255 246 2 251 119 243 166 66 93 81 206 252 77 84 98 45 176 168 7 207 12 131 41 237 102 254 153 176 240 177 51 61 79 167 12 162 19 159 163 249 109 198 234 36 58 67 164 153 163 34 205 98 248 222 255 186 209 145 35 101 188 110 10 188 232 233 147 51 241 20 172 116 38 9 130 102 58 177 51 113 82 243 210 199 111 50 248 28 205 194 102 119 202 153 175 139 130 24 125 202 10 195 52 153 210 230 21 15 27 37 82 146 91 245 42 16 188 114 243 154 161 55 75 97 208 90 201 149 134 130 142 167 193 231 104 22 118 152 235 12 68 123 206 162 156 16 209 242 167 65 111 53 52 223 75 241 67 152 70 209 17 115 1 129 120 244 50 123 101 91 101 16 172 7 158 6 95 156 216 214 188 248 145 46 216 157 124 109 153 82 211 104 131 85 233 139 152 51 227 221 210 230 85 99 21 171 40 76 34 119 250 234 69 93 208 219 11 225 244 246 252 197 25 193 211 224 149 131 223 41 241 218 225 96 56 229 176 139 217 167 239 70 176 191 135 139 226 169 242 90 228 80 245 164 143 123 175 162 22 139 155 51 130 166 210 171 63 75 97 179 137 104 188 246 239 249 141 247 245 183 163 200 169 84 69 74 163 99 212 149 199 148 208 116 234 248 34 96 235 197 202 242 81 162 105 163 13 85 85 229 255 254 190 138 25 249 157 145 14 140 116 96 164 3 35 29 248 227 119 224 191 181 126 227 0 24 176 142 124 0 0 0 0 73 69 78 68 174 66 96 130]! !
!UI.Examples.Ball class categoriesForMethods!
blueIcon!constants!public! !
greenIcon!constants!public! !
icon!constants!public! !
redIcon!constants!public! !
yellowIcon!constants!public! !
!
