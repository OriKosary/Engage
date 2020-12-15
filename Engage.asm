
IDEAL
MODEL small
STACK 1000h
DATASEG

; --------------------------
; Your variables here



Color  dw 4

x	dw	160
y	dw	100
Helper db 0

didEngaged dw 0
;times0 dw 10
;timess dw 10


;clock equ es:6Ch
numOfRoundsMsg db 13,10,'Please enter the number of points a player needs to achieve in order to win :',13,10,'$'
startMessage db 13,10,'Welcome to my game. P1 moves with W,A,S,D and P2 moves with J,K,L,I when both   players are ready please press s to start',13,10,'$'
ChooseDifficultyMsg db 13,10,'Harder = More you can move every turn $',13,10,'$'


reTryMessage db 13,10,'please press s to start',13,10,'$'
reTryMessage2 db 13,10,'please press a number to countinue',13,10,'$'
scoreRed dw 0
scoreBlue dw 0
redMessege db 13,10,'Red  $'
blueMessage db 13,10,'Blue $'
lastXP1 dw 100
lastYP1 dw 100
lastXP2 dw 250
lastYP2 dw 100
filename3 db 'WinSP2.bmp',0 
filename2 db 'Diff.bmp',0
filename db 'WinSP1.bmp',0 
filehandle dw  ? 
Header db 54 dup (0) 
Palette db 256*4 dup (0) 
ScrLine db 320 dup (0)
ErrorMsg db 'Error$'
horLength dw 320
verLength dw 200
numOfRounds dw ?

;helperForTheNumOfRounds dw ?


minX dw 0
maxX dw 0
minY dw 0
maxY dw 0
numOfPixelsYouCanMove dw 100
DistanceX dw 250
heightY dw 170
isHard dw 0
;DistanceXTri dw 0
; --------------------

CODESEG

; This proc 
proc getPixelColorP1
push ax
push cx
push dx

	mov bh,0h
	mov cx,[x]
	mov dx,[y]
	mov ah,0Dh
	int 10h ;  al the pixel value read
	cmp al, 0 ;cmp to black
	je Good
	jne notGood
	notGood:
	add [scoreRed], 1
	add [didEngaged], 1
	jmp EndRound
	Good:

pop dx
pop cx
pop ax
ret
endp getPixelColorP1

proc getPixelColorP2
push ax
push cx
push dx

	mov bh,0h
	mov cx,[x]
	mov dx,[y]
	mov ah,0Dh
	int 10h ; return al the pixel value read
	cmp al, 0 ;cmp to black
	je Good2
	jne notGood2
	notGood2:
	add [scoreBlue], 1
	add [didEngaged], 1
	jmp EndRound
	Good2:

pop dx
pop cx
pop ax
ret
endp getPixelColorP2


proc moveP1
; אנו עומדים להשתמש באוגרים הללו ולשנות אותם אז מאחסנים אותם במחסנית עד לסיום ההפעלה של הפעולה

	; from the help of assembly:
	;INT 10h / AH = 0Ch - change color for a single pixel.
	;AL = pixel color - you have to try your color number...
	;CX = column.
	;DX = row.
	
	
push ax 
push bx 
push cx 
push dx

	
	mov cx, [numOfPixelsYouCanMove]
	cmp [Helper], 0
	je firstTurn
	jne move
	firstTurn:
	mov [x], 100
	mov [y], 100
	add [Helper], 1
	mov [color], 1
	call aPixel
	move: 
	mov dx, [lastXP1]
	mov [x], dx
	mov dx, [lastYP1]
	mov [y], dx
	
	moveb:
	mov [color], 1
	mov ah, 00h
	int 16h
	cmp al, 'd'
	je moveRight
	jne next
	moveRight:
	call aPixel
	add [x], 1
	call getPixelColorP1
	call aPixel
	next:
	cmp al, 'a'
	je moveLeft
	jne next2
	moveLeft:
	call aPixel
	sub [x], 1
	call getPixelColorP1
	call aPixel
	next2:
	cmp al, 'w'
	je moveUp
	jne next3
	moveUp:
	call aPixel
	sub [y], 1
	call getPixelColorP1
	call aPixel
	next3:
	cmp al,'s'
	je moveDown 
	jne next4
	moveDown:
	call aPixel
	add [y], 1
	call getPixelColorP1
	call aPixel
	next4:
	loop moveb
	mov ax, [x]
	mov [lastXP1], ax
	mov bx, [y]
	mov [lastYP1], bx
	
	dis:
 ;----------------------------------------------
	
; לםני החזרה לתכנית הראשית שולפים מהזיכרון את האוגרים מהחסנית - השליפה בסדר הפוך כי ככה עובדת מחסנית	
pop dx
pop cx
pop bx
pop ax
ret 
endp moveP1

proc moveP2
; אנו עומדים להשתמש באוגרים הללו ולשנות אותם אז מאחסנים אותם במחסנית עד לסיום ההפעלה של הפעולה

	; from the help of assembly:
	;INT 10h / AH = 0Ch - change color for a single pixel.
	;AL = pixel color - you have to try your color number...
	;CX = column.
	;DX = row.
	
	
push ax 
push bx 
push cx 
push dx

	mov cx, [numOfPixelsYouCanMove]
	cmp [Helper], 1
	je firstTurn2
	jne move2
	firstTurn2:
	mov [x], 250
	mov [y], 100
	mov [Color] , 4
	call aPixel
	add [Helper], 1
	move2:
	mov [Color], 4
	mov dx, [lastXP2]
	mov [x], dx
	mov dx, [lastYP2]
	mov [y], dx
	
	move2b:
	mov ah, 00h
	int 16h
	cmp al, 'l'
	je moveRight2
	jne next20
	moveRight2:
	call aPixel
	add [x], 1
	call getPixelColorP2
	call aPixel
	next20:
	cmp al, 'j'
	je moveLeft2
	jne next22
	moveLeft2:
	call aPixel
	sub [x], 1
	call getPixelColorP2
	call aPixel
	next22:
	cmp al, 'i'
	je moveUp2
	jne next32
	moveUp2:
	call aPixel
	sub [y], 1
	call getPixelColorP2
	call aPixel
	next32:
	cmp al,'k'
	je moveDown2 
	jne next42
	moveDown2:
	call aPixel
	add [y], 1
	call getPixelColorP2
	call aPixel
	next42:
	loop move2b
	mov ax, [x]
	mov [lastXP2], ax
	mov bx, [y]
	mov [lastYP2], bx

	dis2:
 ;----------------------------------------------
	
; לםני החזרה לתכנית הראשית שולפים מהזיכרון את האוגרים מהחסנית - השליפה בסדר הפוך כי ככה עובדת מחסנית	
pop dx
pop cx
pop bx
pop ax
ret 
endp moveP2

proc aPixel 


	; from the help of assembly:
	;INT 10h / AH = 0Ch - change color for a single pixel.
	;AL = pixel color - you have to try your color number...
	;CX = column.
	;DX = row.
	
	
push ax 
push bx 
push cx 
push dx

;paintPixel:
	
	mov bh,0h 
	mov cx, [x]
	mov dx, [y] 
	mov ax, [color]
	mov ah,0ch 
	int 10h 
 ; ----------- 1 pixel was printed
	

pop dx
pop cx
pop bx
pop ax
ret 
endp aPixel 

proc printScore

push [scoreRed]
push [scoreBlue]
push bp 

mov bp,sp
red  equ [bp + 4]
blue equ [bp + 2] 

	;----Red-------------
	;--------------------
=
 
 
 
pop bp
pop [scoreBlue]
pop [scoreRed]
ret 
endp printScore
    
proc createShape
push ax
push bx 
push cx 
push dx
push [DistanceX]
push [heightY]
push bp

mov bp,sp
LongTzela equ [bp + 4]
ShortTzela equ [bp + 2] 

	;Here you put the starting point of the rectangle
	mov [x],55
	mov [y],10
	mov [color],7

	;length X
	mov cx, LongTzela
	formX : ; ציר ה-X
	call aPixel
	add [x],1
	call aPixel
	loop formX

	;length Y
	mov cx, ShortTzela
	formY : ;ציר הY
	call aPixel
	add [y],1
	call aPixel
	loop formY

	mov cx, LongTzela
	formX2 : ;ציר ה-X השני
	call aPixel
	sub [x],1	
	call aPixel
	loop formX2
	
	mov cx, ShortTzela
	formY2 :
	call aPixel
	sub [y], 1
	call aPixel
	loop formY2

	
pop bp
pop [heightY]
pop [DistanceX]
pop dx
pop cx
pop bx
pop ax
ret 
endp createShape

proc OpenFile 

	; Opens file 
	mov ah, 3Dh 
    xor al, al 
    int 21h
	jc openerror
    mov [filehandle], ax
    ret 
              
    ;printing error message
    openerror: 
    mov dx, offset ErrorMsg 
    mov ah, 9h 
    int 21h 
    ret  
	
endp OpenFile 
 
proc ReadHeader 
 
	; Read BMP file header, 54 bytes 
    mov ah, 3fh 
    mov bx, [filehandle] 
    mov cx, 54  
    mov dx, offset Header 
    int 21h   
	
	ret
              
endp ReadHeader  
 
proc ReadPalette 

	; Read BMP file color palette, 256 colors * 4 bytes (400h) 
    mov ah, 3fh 
    mov cx, 400h                           
    mov dx, offset Palette 
    int 21h    
	
    ret 
              
endp ReadPalette  
 
proc CopyPal
  
	; Copy the colors palette to the video memory  
    ; The number of the first color should be sent to port 3C8h 
	; The palette is sent to port 3C9h 
    mov si,offset Palette        
    mov cx,256               
    mov dx,3C8h 
    mov al,0                     
    ; Copy starting color to port 3C8h 
    out dx,al 
    ; Copy palette itself to port 3C9h  
    inc dx  
              
    PalLoop: 
    ; Note: Colors in a BMP file are saved as BGR values rather than RGB. 
    mov al,[si+2] ; Get red value. 
    shr al,2 ; Max. is 255, but video palette maximal value is 63. Therefore dividing by 4. 
    out dx,al ; Send it. 
    mov al,[si+1] ; Get green value. 
    shr al,2 
    out dx,al ; Send it. 
    mov al,[si] ; Get blue value. 
    shr al,2 
    out dx,al ; Send it. 
    add si,4 ; Point to next color. 
    ;(There is a null chr. after every color.) 
	
    loop PalLoop 
	
    ret 
              
endp CopyPal  
 
proc CopyBitmap 

	; BMP graphics are saved upside-down. 
    ; Read the graphic line by line (200 lines in VGA format), 
    ; displaying the lines from bottom to top.  
    mov ax, 0A000h 
    mov es, ax 
    mov cx,200               
    PrintBMPLoop: 
    push cx 
    ; di = cx*320, point to the correct screen line 
	mov di,cx                    
    shl cx,6                     
    shl di,8                     
    add di,cx 
    ; Read one line 
    mov ah,3fh 
	mov cx,320 
    mov dx,offset ScrLine 
    int 21h                      
    ; Copy one line into video memory 
    cld ; Clear direction flag, for movsb 
    mov cx,320 
    mov si,offset ScrLine 
    rep movsb ; Copy line to the screen  
    ;rep movsb is same as the following code: 
    ;mov es:di, ds:si 
    ;inc si 
    ;inc di 
	;dec cx 
    ;loop until cx=0      
    pop cx 
	loop PrintBMPLoop 
			  
    ret 
              
endp CopyBitmap
   
; draws difficulty Screen
proc DrawDifficultyScreen
		
	; Graphic mode 	
	mov ax, 13h 
	int 10h
	
    ; Process BMP file 
	;difficultyScreen equ filename2
    mov dx, offset filename2
    call OpenFile 
    call ReadHeader 
    call ReadPalette 
    call CopyPal 
	call CopyBitmap 
	
	ret 
	
endp DrawDifficultyScreen

proc printDifficultyMsg

	;----ChooseDifficultyMsg--
	;-------------------------
	mov  dl, 0  ;Column
	mov  dh, 0   ;Row
	mov  bh, 0    ;Display page
	mov  ah, 02h  ;SetCursorPosition
	int  10h

	mov dx, offset ChooseDifficultyMsg
	mov ah,9 
	int 21h
 
	mov  bl, 7
	mov  bh, 0    ;Display page
	mov  ah, 0Eh  ;Teletype
	int  10h
	
	ret 
	
endp printDifficultyMsg

; Draws P1 win screen
proc DrawP1WinScreen

    ; Process BMP file 
	P1WinScreen equ filename
    mov dx, offset P1WinScreen
    call OpenFile 
    call ReadHeader 
    call ReadPalette 
    call CopyPal 
	call CopyBitmap 
 
	ret
	
endp DrawP1WinScreen
 
 ; Draws P2 win screen
proc DrawP2WinScreen

    ; Process BMP file 
	P2WinScreen equ filename3
    mov dx, offset P2WinScreen
    call OpenFile 
    call ReadHeader 
    call ReadPalette 
    call CopyPal 
	call CopyBitmap 
 
	ret
	
endp DrawP2WinScreen
 
proc createLine

push [x]
push ax 
push bx 
push cx 
push dx
;push [horLength]
;push bp

;mov bp,sp
;hotizontalLength equ [bp + 2]

	mov [x], 0
	mov [color], 0
	mov cx, [horLength]
	formX3:
	call aPixel
	add [x],1
	loop formX3

pop dx
pop cx
pop bx
pop ax
pop [x]
ret 

endp createLine

  
proc clearGame

push[y]
push ax 
push bx 
push cx 
push dx

	mov [color], 0
	mov cx, [verLength]
	formRec:
	call createLine
	add [y],1
	loop formRec

pop dx
pop cx
pop bx
pop ax
pop[y]
ret

endp clearGame

proc getNumOfRounds 

	GetRoundsCorrectly:
	mov dx, offset numOfRoundsMsg
	mov ah, 9h
	int 21h

	mov ah, 1
	int 21h	 ; saved in AL
	sub al,30h

	cmp al,0
	jne cmpOne
	mov [numOfRounds], 9
	jmp gotNumOfRounds 
	
	cmpOne:
	cmp al,1
	jne cmpTwo
	mov [numOfRounds], 1
	jmp gotNumOfRounds 
	
	cmpTwo:
	cmp al,2
	jne cmpThree
	mov [numOfRounds], 2
	jmp gotNumOfRounds 
	
	cmpThree:
	cmp al,3
	jne cmpFour
	mov [numOfRounds], 3
	jmp gotNumOfRounds 
	
	cmpFour:
	cmp al,4
	jne cmpFive
	mov [numOfRounds], 4
	jmp gotNumOfRounds 
	
	cmpFive:
	cmp al,5
	jne cmpSix
	mov [numOfRounds], 5
	jmp gotNumOfRounds 
	
	cmpSix:
	cmp al,6
	jne cmpSeven
	mov [numOfRounds], 6
	jmp gotNumOfRounds 
	
	cmpSeven:
	cmp al,7
	jne cmpEight
	mov [numOfRounds], 7
	jmp gotNumOfRounds 
	
	cmpEight:
	cmp al,8
	jne cmpNine
	mov [numOfRounds], 8
	jmp gotNumOfRounds 
	
	cmpNine:
	cmp al,9
	jne AlNotQualfied
	mov [numOfRounds], 9
	jmp gotNumOfRounds 
	
	AlNotQualfied:
	jmp GetRoundsCorrectly
	
	ret
	
endp getNumOfRounds

proc InitializeMouse

    ; Initializes the mouse
    mov ax,0h
    int 33h

    ; Shows mouse
    mov ax,1h
    int 33h

    ret

endp InitializeMouse

proc DisableMouse

    ; Hides mouse
    mov ax,02
    int 33h

    ret

endp DisableMouse

proc SelectLevel

; Stage aspect ratio =
;250x170 X is bigger than Y by 250:170 ≈ for each pixel for Y add 1.5 pixels to X
;Easy - 250x170
;Medium - is will stay the same
;Hard will be a diffrent stage


push ax
push bx
push cx
push dx

    ; Loop until mouse left click
    MouseLPPP:
    mov ax,3h
    int 33h
    cmp bx, 01h ; checks left mouse click
    jne MouseLPPP

    Easy:
    ;easy button coordinates
    mov [minX], 009Eh
    mov [maxX], 01DEh
    mov [maxY], 0058h
    mov [minY], 0041h

    cmp cx, [minX]
    jl Mediumm
    ;----------------
    continueee1:
    cmp cx, [maxX]
    jg Mediumm
    ;----------------
    continueee2:
    cmp dx, [maxY]
    jg Mediumm
    ;----------------
    continueee3:
    cmp dx, [minY]
    jl Mediumm
	mov [numOfPixelsYouCanMove],100
    jmp doneeee

    Mediumm:
    mov [minX], 009Eh
    mov [maxX], 01DEh
    mov [maxY], 0075h
    mov [minY], 005Fh 

    cmp cx, [minX]
    jl Hard
    ;----------------
    continueeee1:
    cmp cx, [maxX]
    jg Hard
    ;----------------
    continueeee2:
    cmp dx, [maxY]
    jg Hard
    ;----------------
    continueeee3:
    cmp dx, [minY]
    jl Hard
	mov [numOfPixelsYouCanMove],150
    jmp doneeee

    Hard:
    mov [minX], 009Eh
    mov [maxX], 01DEh
    mov [maxY], 0094h
    mov [minY], 007Ch

    cmp cx, [minX]
    jl NoButtonDetected
    ;----------------
    continueeeee1:
    cmp cx, [maxX]
    jg NoButtonDetected
    ;----------------
    continueeeee2:
    cmp dx, [maxY]
    jg NoButtonDetected
    ;----------------
    continueeeee3:
    cmp dx, [minY]
    jl NoButtonDetected
	mov [numOfPixelsYouCanMove],200
	add [isHard], 1
    jmp doneeee
    ;----------------
    NoButtonDetected:
    jmp MouseLPPP

doneeee:
call DisableMouse

pop dx
pop cx
pop bx
pop ax

ret

endp SelectLevel

proc createHardShape
push ax
push bx 
push cx 
push dx
push [DistanceX]
push [heightY]
push bp

mov bp,sp
TzelaParallelToX equ [bp + 4]
TzelaParallelToY equ [bp + 2] 

	;Here you put the starting point of the rectangle
	mov [x],115
	mov [y],10
	mov [color],7
	call aPixel

	;The h's after the names stand for hard
	
	mov TzelaParallelToX, 75
	mov cx, TzelaParallelToX
	formXH : 
	call aPixel
	add [x],1
	call aPixel
	loop formXH

	mov TzelaParallelToY, 61
	mov cx, TzelaParallelToY
	formYH:
	call aPixel
	add [y],1
	call aPixel
	loop formYH
	
	mov cx, TzelaParallelToX
	formXH2 : 
	call aPixel
	add [x],1
	call aPixel
	loop formXH2
	
	mov cx, TzelaParallelToY
	formYH2:
	call aPixel
	add [y],1
	call aPixel
	loop formYH2
	
	mov cx, TzelaParallelToX
	formXH3 : 
	call aPixel
	sub [x],1
	call aPixel
	loop formXH3
	
	mov cx, TzelaParallelToY
	formYH3:
	call aPixel
	add [y],1
	call aPixel
	loop formYH3
	
	mov cx, TzelaParallelToX
	formXH4 : 
	call aPixel
	sub [x],1
	call aPixel
	loop formXH4
	
	mov cx, TzelaParallelToY
	formYH4:
	call aPixel
	sub [y],1
	call aPixel
	loop formYH4
	
	mov cx, TzelaParallelToX
	formXH5 : 
	call aPixel
	sub [x],1
	call aPixel
	loop formXH5
	
	mov cx, TzelaParallelToY
	formYH5:
	call aPixel
	sub [y],1
	call aPixel
	loop formYH5
	
	mov cx, TzelaParallelToX
	formXH6 : 
	call aPixel
	add [x],1
	call aPixel
	loop formXH6
	
	mov cx, TzelaParallelToY
	formYH6:
	call aPixel
	sub [y],1
	call aPixel
	loop formYH6
		
pop bp
pop [heightY]
pop [DistanceX]
pop dx
pop cx
pop bx
pop ax

ret
 
endp createHardShape

start:
	mov ax, @data
	mov ds, ax
; --------------------------
; Your code here
; -----------------------
;main Main
	;Player 1 = Red
	;Player 2 = Blue
	;jmp e 
	
	call getNumOfRounds
	gotNumOfRounds:
	
	call DrawDifficultyScreen
	;call printDifficultyMsg
	call InitializeMouse
	call SelectLevel
	call clearGame
	
	; return to text mode
	mov ah, 0
	mov al, 2
	int 10h
	
	
	mov dx, offset startMessage
	mov ah, 9h
	int 21h
	tryAgain:
	mov ah, 00h
	int 16h
	cmp al, 's'
	jne no
	je startGame
	startGame :
	
	; Graphic mode 	
	mov ax, 13h 
	int 10h
	
	;jmp e
	call printScore
	cmp [isHard],0
	je continueNormal
	jne HardDifficultyChosen
	continueNormal:
	call createShape
	jmp nxtt
	HardDifficultyChosen:
	call createHardShape
	nxtt:
	; if Helper = 0 - p1Turn else - p2Turn
	Game:
	
	call moveP1
	call moveP2
	
	EndRound:
	cmp [didEngaged], 0
	je game
	jne roundEnded
	
	roundEnded:
	sub [didEngaged], 1
	
	call clearGame
	
	call clearGame
	call printScore
	
	cmp [isHard],0
	je continueNormall
	jne HardDifficultyChosenn
	continueNormall:
	call createShape
	jmp nxt
	HardDifficultyChosenn:
	call createHardShape
	;call createShape
	nxt:	
	;The player signs in the pictures are oppisite on purpose because its the ink of the enemy 
	
	mov bx,[numOfRounds]
	cmp [scoreRed], bx
	je player1Won
	
	cmp [scoreBlue],bx
	je player2Won
	
	jmp Game
	

	player1Won:
	call DrawP1WinScreen
	jmp nearEnd
	
	player2Won:
	call DrawP2WinScreen
	jmp nearEnd
	
	no:
	mov dx, offset reTryMessage
	mov ah, 9h
	int 21h
	jmp tryAgain
	nearEnd:
	
	
	
	;e:
	; Graphic mode 	
	;mov ax, 13h 
	;int 10h
	;call printScore
	;call createHardShape
;----------------------------------------------
; waits for key press
mov ah, 00h
int 16h
; return to text mode
mov ah, 0
mov al, 2
int 10h
	
	
exit:
	
mov ax, 4c00h
int 21h
END start
