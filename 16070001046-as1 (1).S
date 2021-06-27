/* jump search implementation in x64 Assembly -- ATABERK TAY --*/
.intel_syntax noprefix
.section .data
output:
	.asciz "%lu "
output2:
	.asciz "\nFailure message\n "
output3:
	.asciz "Integer square root of "
output4:
	.asciz "is "
output5:
	.asciz "\nItem found at location: "
value:
	.quad 5, 10, 20, 40, 45, 55, 70, 75, 90, 95

.section .text

########################################
.global main
main:
	#push 10				Size ı pushlamak istersem

	mov r8, 10				# array size
	lea rdi, value			# get starting address of value
	mov rsi, 55				# item = 55

	call jump_search


	#add rsp, 13				# pop 10 gibi	(Size ı pushlamak istersem poplamak için!)

exit:
	ret
########################################


########################################
.global jump_search
jump_search:
	push rbp
	mov rbp, rsp

	push rbx
	push r12
	push r13
	push r14
	push r15

	mov r13, 0				# i = 0

	call sqrt

	mov r9, rcx 			# m = sqrt(size);
	mov r10, r9				# t = m;
	while1:
		mov r12, r13					# x = i
		mov rax, [rdi + r9*8]
		cmp [rdi + r9*8], rsi			# a[m] <= item
		jg for1
		cmp r9, r8						# m < size
		jge for1

		mov r13, r9						# i = m
		add r9, r10						# m = m + t
		mov r11, r8						# r11 = array_size
		dec r11							# size--
		if1:
			cmp r13, r11					# i > size - 1
			jle if1_exit
			#return -1
			jmp while1
		if1_exit:
			jmp while1

	for1:
		cmp r12, r9						# x < m
		jge	for1_exit
		if2:
			mov rax, [rdi + r12*8]
			cmp [rdi + r12*8], rsi
			jne	if2_exit
			#return x	print "Item found at location: "
			push rax
			push rcx
			lea rdi, [rip + output5]
			mov rsi, rax
			xor rax, rax
			call printf
			pop rcx
			pop rax
			
			mov rax, r12					# print index
			
			push rax
			push rcx
			lea rdi, [rip + output]
			mov rsi, rax
			xor rax, rax
			call printf
			pop rcx
			pop rax
			
			jmp exit2

		if2_exit:
			inc r12
			jmp for1

	for1_exit:
		push rax
		push rcx
		lea rdi, [rip + output2]
		mov rsi, rax
		xor rax, rax
		call printf
		pop rcx
		pop rax

		#return -1		print failure

exit2:
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rbp
	ret


########################################


########################################
.global sqrt
sqrt:
	push rbp
	mov rbp, rsp

	push rbx
	push r12
	push r13
	push r14
	push r15

	## Initial estimate
	mov rax, 0
	mov rdx, 0
	mov rax, 10			#num = 10 (bölünecek sayı)
	mov rbx, 2			#bölüm	 (2)
	div rbx
	## Initial estimate
	
	## update
	mov rcx, 0			#rcx'i 0 lıyorum
	mov rcx,rax			# x0
	mov r13, rcx			# x0
	
	xor rax, rax		#rax'ı 0 lıyorum
	mov rax, 10
	div rcx
	
	mov r14, rax		# r14 = num / x0
	
	add r13, r14			# x0 + num / x0
	
	xor rax,rax			#rax'ı 0 lıyorum
	mov rax, r13
	div rbx				#( x0 + num / x0 ) / 2
	
	xor r9,r9
	mov r9, rax			#x1
	## update
	
	sqrt_while:
		cmp r9,rcx			# x1 < x0
		jge sqrt_while_exit
		mov rcx, r9			# x0 = x1;
		xor rax, rax		# rax'ı 0 lıyorum
		mov rax, 10			# number = 10
		mov rdx, 0
		div rcx				# number / x0
		
		mov r13, rcx			# r13 = x0
		add r13, rax			# x0 + num / x0

		xor rax,rax			#rax'ı 0 lıyorum
		mov rax, r13
		mov rdx, 0
		div rbx				#( x0 + num / x0 ) / 2

		xor r9,r9
		mov r9, rax			# x1
		jmp sqrt_while

	sqrt_while_exit:		# Print

		#printing "INTEGER SQUARE ROOT OF"
		push rax
		push rcx
		lea rdi, [rip + output3]
		mov rsi, rax
		xor rax, rax
		call printf
		pop rcx
		pop rax

		mov rax, 10		# print size

		push rax
		push rcx
		lea rdi, [rip + output]
		mov rsi, rax
		xor rax, rax
		call printf
		pop rcx
		pop rax

		#print "is"
		push rax
		push rcx
		lea rdi, [rip + output4]
		mov rsi, rax
		xor rax, rax
		call printf
		pop rcx
		pop rax

		mov rax, rcx		# print x0 (3)

		push rax
		push rcx
		lea rdi, [rip + output]
		mov rsi, rax
		xor rax, rax
		call printf
		pop rcx
		pop rax

	#print işlemleri registerları bozdugu için tekrar güncelliyorum
	mov r8, 10				# array size
	lea rdi, value			# get starting address of value
	mov rsi, 55				# item = 55

	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rbp
	ret











