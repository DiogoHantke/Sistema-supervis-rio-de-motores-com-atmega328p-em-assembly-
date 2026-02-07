;controlador do motor - COM LCD

.include "m328Pdef.inc"

.equ on_off = PB0       
.equ btn_enter = PB1       
.equ btn_emergencia = PB3  
.equ btn_baixo = PB4       
.equ btn_cima = PB5        
.equ sensor_temp = PC1     
.equ sensor_corrente = PC3 

.equ contador_seg_memory = 0x0150
.equ contador_min_memory = 0x0166
.equ flag_emergencia  = 0x017C
.equ value_corrente = 0x0180
.equ value_temperatura =  0x0189

.def cont = r25
.def mux_analog = r30
.def aux2 = r26

.org 0x000
    rjmp init       

.org 0x0020  
    rjmp timr0

.org 0x050    

.include "lib328Pv03.inc"

init:
    ldi aux, high(RAMEND)
    out SPH, aux
    ldi aux, low(RAMEND)
    out SPL, aux

    ldi aux, 0b00000001 
    out DDRB, aux
    ldi aux, 0b00111010 
    out PORTB, aux
    ldi aux, 0b00000000
    out PORTC, aux
    
    ldi aux, 0
	ldi cont, 0
    sts contador_seg_memory, aux
    rcall usart_init  
    rcall lcd_init
    rcall lcd_clear  
	rjmp state_1

config_timer:
    ldi aux, 0b01010000
    out TCCR0A, aux
    ldi aux,0b00000001 
    sts TIMSK0,aux
    ldi aux,0b00000101
    out TCCR0B,aux 
    ldi aux,100 
    out TCNT0,aux
    sei 
	rjmp loop

;============ configuração =============

state_1:; definir modos
    ldi lcd_col, 7  
    rcall lcd_lin0_col
    ldi lcd_caracter, 'B'
    rcall lcd_write_caracter
    ldi lcd_caracter, 'E'
    rcall lcd_write_caracter
	ldi lcd_caracter, 'M'
	rcall lcd_write_caracter
	ldi lcd_col, 6
    rcall lcd_lin1_col
    ldi lcd_caracter, 'V'
	rcall lcd_write_caracter
	ldi lcd_caracter, 'I'
    rcall lcd_write_caracter
	ldi lcd_caracter, 'N'
    rcall lcd_write_caracter
	ldi lcd_caracter, 'D'
    rcall lcd_write_caracter
	ldi lcd_caracter, 'O'
    rcall lcd_write_caracter
	ldi lcd_caracter, ' '
    rcall lcd_write_caracter
	ldi lcd_caracter, ':'
    rcall lcd_write_caracter
	ldi lcd_caracter, ')'
    rcall lcd_write_caracter

	ldi delay_time, 2 ;mudar o tempo 
	rcall delay_seconds
	rcall state_cima

	rcall lcd_clear
    ldi lcd_col, 2  
    rcall lcd_lin0_col
    ldi lcd_caracter, 'D'
    rcall lcd_write_caracter
    ldi lcd_caracter, 'E'
    rcall lcd_write_caracter
	ldi lcd_caracter, 'F'
    rcall lcd_write_caracter
	ldi lcd_caracter, 'I'
    rcall lcd_write_caracter
	ldi lcd_caracter, 'N'
    rcall lcd_write_caracter
	ldi lcd_caracter, 'I'
    rcall lcd_write_caracter
	ldi lcd_caracter, 'R'
    rcall lcd_write_caracter

	ldi lcd_col, 9
    rcall lcd_lin0_col
    ldi lcd_caracter, ' '
	rcall lcd_write_caracter
	ldi lcd_caracter, 'M'
    rcall lcd_write_caracter
	ldi lcd_caracter, 'O'
    rcall lcd_write_caracter
	ldi lcd_caracter, 'D'
    rcall lcd_write_caracter
	ldi lcd_caracter, 'O'
    rcall lcd_write_caracter

	ldi lcd_col, 1
    rcall lcd_lin1_col
    ldi lcd_caracter, '-'
	rcall lcd_write_caracter
    ldi lcd_caracter, ' '

	ldi lcd_col, 14
    rcall lcd_lin1_col
	ldi lcd_caracter, '+'
	rcall lcd_write_caracter
	ldi aux, 0
	ldi delay_time, 2 ;mudar o tempo 
	rcall delay_seconds
	rcall state_cima

; ====== lógica de mudança de menu =======
state_escolha:
    sbis pinb, btn_baixo
    rcall debounce_baixo

    sbis pinb, btn_cima
    rcall debounce_cima

	sbis pinb, btn_enter
    rcall state_enter

    rjmp state_escolha


corrige_baixo:
	mov aux, aux2
	rjmp state_baixo

debounce_baixo:
    sbis pinb, btn_baixo
    rjmp debounce_baixo
	mov aux2, aux
	dec aux
	cpi aux, 3
	brsh corrige_baixo

state_baixo:
    sbis pinb, btn_baixo
    rjmp state_baixo
	cpi aux, 0
	breq jump_state_escolha_1
	cpi aux, 1
	breq jump_state_escolha_2
	cpi aux, 2
	breq jump_state_escolha_3
	ret

corrige_cima:	
	mov aux, aux2
	rjmp state_cima


debounce_cima:
    sbis pinb, btn_cima
    rjmp debounce_cima
	mov aux2, aux
    inc aux
	cpi aux, 3
	brsh corrige_cima

state_cima:
	cpi aux, 0
	breq jump_state_escolha_1
	cpi aux, 1
	breq jump_state_escolha_2
	cpi aux, 2
	breq jump_state_escolha_3
	ret

jump_state_escolha_1:
    rjmp state_escolha_1

jump_state_escolha_2:
    rjmp state_escolha_2

jump_state_escolha_3:
    rjmp state_escolha_3

state_escolha_3:
	rcall lcd_clear
	ldi lcd_col, 1
    rcall lcd_lin1_col
	ldi lcd_caracter, '-'
	rcall lcd_write_caracter
	ldi lcd_col, 6
    rcall lcd_lin0_col
	ldi lcd_caracter, 'M'
    rcall lcd_write_caracter
	ldi lcd_caracter, 'O'
    rcall lcd_write_caracter
	ldi lcd_caracter, 'D'
    rcall lcd_write_caracter
	ldi lcd_caracter, 'O'
    rcall lcd_write_caracter

	ldi lcd_col, 3
    rcall lcd_lin1_col
	ldi lcd_caracter, 'S'
    rcall lcd_write_caracter
	ldi lcd_caracter, 'A'
    rcall lcd_write_caracter
	ldi lcd_caracter, 'L'
    rcall lcd_write_caracter
	ldi lcd_caracter, 'V'
    rcall lcd_write_caracter
	ldi lcd_caracter, 'A'
    rcall lcd_write_caracter
	ldi lcd_caracter, 'M'
    rcall lcd_write_caracter
	ldi lcd_caracter, 'E'
    rcall lcd_write_caracter
	ldi lcd_caracter, 'N'
    rcall lcd_write_caracter
	ldi lcd_caracter, 'T'
    rcall lcd_write_caracter
	ldi lcd_caracter, 'O'
    rcall lcd_write_caracter
	ldi lcd_col, 14
	rcall lcd_lin1_col
	ldi lcd_caracter, '+'
    rcall lcd_write_caracter
	ret

state_escolha_2:
    rcall lcd_clear
	ldi lcd_col, 1
    rcall lcd_lin1_col
	ldi lcd_caracter, '-'
	rcall lcd_write_caracter
	ldi lcd_col, 6
    rcall lcd_lin0_col
	ldi lcd_caracter, 'M'
    rcall lcd_write_caracter
	ldi lcd_caracter, 'O'
    rcall lcd_write_caracter
	ldi lcd_caracter, 'D'
    rcall lcd_write_caracter
	ldi lcd_caracter, 'O'
    rcall lcd_write_caracter

	ldi lcd_col, 4
    rcall lcd_lin1_col
	ldi lcd_caracter, 'S'
    rcall lcd_write_caracter
	ldi lcd_caracter, 'O'
    rcall lcd_write_caracter
	ldi lcd_caracter, 'F'
    rcall lcd_write_caracter
	ldi lcd_caracter, 'T'
    rcall lcd_write_caracter
	ldi lcd_caracter, 'S'
    rcall lcd_write_caracter
	ldi lcd_caracter, 'T'
    rcall lcd_write_caracter
	ldi lcd_caracter, 'A'
    rcall lcd_write_caracter
	ldi lcd_caracter, 'R'
    rcall lcd_write_caracter
	ldi lcd_caracter, 'T'
    rcall lcd_write_caracter
	ldi lcd_col, 14
    rcall lcd_lin1_col
	ldi lcd_caracter, '+'
    rcall lcd_write_caracter
	ret

state_escolha_1:
    rcall lcd_clear
	ldi lcd_col, 1
    rcall lcd_lin1_col
	ldi lcd_caracter, '-'
	rcall lcd_write_caracter
	ldi lcd_col, 6
    rcall lcd_lin0_col
	ldi lcd_caracter, 'M'
    rcall lcd_write_caracter
	ldi lcd_caracter, 'O'
    rcall lcd_write_caracter
	ldi lcd_caracter, 'D'
    rcall lcd_write_caracter
	ldi lcd_caracter, 'O'
    rcall lcd_write_caracter
	
	ldi lcd_col, 5
    rcall lcd_lin1_col
	ldi lcd_caracter, 'N'
    rcall lcd_write_caracter
	ldi lcd_caracter, 'O'
    rcall lcd_write_caracter
	ldi lcd_caracter, 'R'
    rcall lcd_write_caracter
	ldi lcd_caracter, 'M'
    rcall lcd_write_caracter
	ldi lcd_caracter, 'A'
    rcall lcd_write_caracter
	ldi lcd_caracter, 'L'
    rcall lcd_write_caracter
	ldi lcd_col, 14
	rcall lcd_lin1_col
	ldi lcd_caracter, '+'
    rcall lcd_write_caracter
	ret

state_enter:
	sbis pinb, btn_enter
	rjmp state_enter
	cpi aux, 2
	breq state_save_text
	cpi aux, 1
	breq state_soft_text
	cpi aux, 0
	breq state_normal_text
	rjmp state_enter

; ====== lógica de mudança de menu =======

state_save_text:


state_soft_text:;colcoar o texto do soft start

; ====== softstart =======
state_soft:
	rjmp state_soft

state_normal_text:
    rcall lcd_clear
	ldi lcd_col, 3
    rcall lcd_lin0_col
	ldi lcd_caracter, 'M'
    rcall lcd_write_caracter
	ldi lcd_caracter, 'O'
    rcall lcd_write_caracter
	ldi lcd_caracter, 'D'
    rcall lcd_write_caracter
	ldi lcd_caracter, 'O'
    rcall lcd_write_caracter
	
	ldi lcd_col, 7
    rcall lcd_lin0_col
	ldi lcd_caracter, ' '
    rcall lcd_write_caracter
	ldi lcd_caracter, 'N'
    rcall lcd_write_caracter
	ldi lcd_caracter, 'O'
    rcall lcd_write_caracter
	ldi lcd_caracter, 'R'
    rcall lcd_write_caracter
	ldi lcd_caracter, 'M'
    rcall lcd_write_caracter
	ldi lcd_caracter, 'A'
    rcall lcd_write_caracter
	ldi lcd_caracter, 'L'
    rcall lcd_write_caracter

	ldi lcd_col, 7
	rcall lcd_lin1_col
	ldi lcd_caracter, 'O'
    rcall lcd_write_caracter
	ldi lcd_caracter, 'N'
	rcall lcd_write_caracter

	ldi aux, 0
	ldi cont, 5
	ldi r21, 0

; ====== modo manual =======
state_normal:
state_escolha_normal:

	cpi r21, 2
	brsh branch_loop

	sbis pinb, btn_baixo
	rcall func_dec

	sbis pinb, btn_cima
	rcall func_inc

	sbis pinb, btn_enter
	rcall state_enter_normal_debounce

	rjmp state_escolha_normal

branch_loop:
	rcall lcd_clear
	sts value_corrente, aux ;carrega na ram
	rjmp config_timer

func_dec:
	sbis pinb, btn_baixo
	rjmp func_dec
	dec aux
	rjmp update_display

func_inc:
	sbis pinb, btn_cima
	rjmp func_inc
	inc aux
	rjmp update_display

state_enter_normal_debounce:
	sbis pinb, btn_enter
	rjmp state_enter_normal_debounce

state_enter_normal:
	sts value_temperatura, aux ;carrega na ram
	rcall lcd_clear
	rcall state_corr_selec
	inc r21
	ret
	
update_display:
	cpi r21, 0
	breq state_temp_selec
	cpi r21, 1
	brsh state_corr_selec
	ret

state_temp_selec:
	rcall lcd_clear
	ldi lcd_col, 2
	rcall lcd_lin0_col
	ldi lcd_caracter, 'T'
	rcall lcd_write_caracter
	ldi lcd_caracter, 'E'
	rcall lcd_write_caracter
	ldi lcd_caracter, 'M'
	rcall lcd_write_caracter
	ldi lcd_caracter, 'P'
	rcall lcd_write_caracter
	ldi lcd_caracter, ' '
	rcall lcd_write_caracter
	ldi lcd_caracter, 'V'
	rcall lcd_write_caracter
	ldi lcd_caracter, 'A'
	rcall lcd_write_caracter
	ldi lcd_caracter, 'L'
	rcall lcd_write_caracter
	ldi lcd_caracter, ':'
	rcall lcd_write_caracter
	ldi lcd_col,7
	rcall lcd_lin1_col
	mov lcd_number,aux
	rcall lcd_write_number
	ret

state_corr_selec:
	rcall lcd_clear
	ldi lcd_col, 2
	rcall lcd_lin0_col
	ldi lcd_caracter, 'C'
	rcall lcd_write_caracter
	ldi lcd_caracter, 'O'
	rcall lcd_write_caracter
	ldi lcd_caracter, 'R'
	rcall lcd_write_caracter
	ldi lcd_caracter, 'R'
	rcall lcd_write_caracter
	ldi lcd_caracter, ' '
	rcall lcd_write_caracter
	ldi lcd_caracter, 'V'
	rcall lcd_write_caracter
	ldi lcd_caracter, 'A'
	rcall lcd_write_caracter
	ldi lcd_caracter, 'L'
	rcall lcd_write_caracter
	ldi lcd_caracter, ':'
	rcall lcd_write_caracter
	ldi lcd_col, 5
	rcall lcd_lin1_col
	mov lcd_number, aux
	rcall lcd_write_number
	ret

rjmp state_normal

;============ loop =================
loop:                            
    rjmp loop 

;============ rotinas de execução do programa principal =============
verifica_btn_emergencia:
    sbic PINB, btn_emergencia 
    ret                         
    rjmp rotina_emergencia   

rotina_emergencia:
    sbic PINB, btn_emergencia 
    rjmp rotina_emergencia
    rcall warning_btn_emergencia

parametro_emergencia:
    ldi aux, high(RAMEND)
    out SPH, aux
    ldi aux, low(RAMEND)
    out SPL, aux
    rcall stop_timer0
    rcall apagar_led
    ldi pwm_value, 0
    rcall pwm_write   
    rcall lcd_emergencia_btn

	loop_travado:
		sbic PINB, btn_enter
		rjmp loop_travado
		rcall corrente
		rcall temperatura
		rcall lcd_clear
		rjmp config_timer

ligar_motor:
    ldi r30, 0b01100000 
    rcall analog_read    
    mov pwm_value, adc_value  
    rcall pwm_write              
    cpi pwm_value, 40
    brsh ligar_led
    brlo apagar_led
    ret

ligar_led:
    sbi PORTB, on_off    
    ret  

apagar_led:   
    ldi pwm_value, 0
    rcall pwm_write 
    cbi PORTB, on_off    
    ret  

stop_timer0:
    ldi aux,0b00000000
    out TCCR0A,aux
    ldi aux,0b00000000 
    sts TIMSK0,aux
    ldi aux,0b00000000
    out TCCR0B,aux 
    ldi aux, 0
    out TCNT0,aux
    ret

corrente:
    ldi r30, 0b01100010;A2
    rcall analog_read  
	lds r30, value_corrente
    mov aux, adc_value
    cp aux, r30
    brsh warning_corrente
    ret

temperatura:
    ldi r30, 0b01100001;A1
    rcall analog_read   
	lds aux2, value_temperatura
    mov aux, adc_value
    cp aux, r30
    brsh warning_temp
    ret

;============ escrita =============

warning_corrente:
    ldi transmit_caracter, ' '
    rcall usart_transmit
    ldi transmit_caracter, 'c'
    rcall usart_transmit
    ldi transmit_caracter, 'o'
    rcall usart_transmit
    ldi transmit_caracter, 'r'
    rcall usart_transmit
    ldi transmit_caracter, 'r'
    rcall usart_transmit
    ldi transmit_caracter, 'e'
    rcall usart_transmit
    ldi transmit_caracter, 'n'
    rcall usart_transmit
    ldi transmit_caracter, 't'
    rcall usart_transmit
    ldi transmit_caracter, 'e'
    rcall usart_transmit
    ldi transmit_caracter, ' '
    rcall usart_transmit
    rjmp parametro_emergencia
    ret

warning_btn_emergencia:
    ldi transmit_caracter, ' '
    rcall usart_transmit
    ldi transmit_caracter, 'e'
    rcall usart_transmit
    ldi transmit_caracter, 'm'
    rcall usart_transmit
    ldi transmit_caracter, 'e'
    rcall usart_transmit
    ldi transmit_caracter, 'r'
    rcall usart_transmit
    ldi transmit_caracter, 'g'
    rcall usart_transmit
    ldi transmit_caracter, 'e'
    rcall usart_transmit
    ldi transmit_caracter, 'n'
    rcall usart_transmit
    ldi transmit_caracter, 'c'
    rcall usart_transmit
    ldi transmit_caracter, 'i'
    rcall usart_transmit
    ldi transmit_caracter, 'a'
    rcall usart_transmit
    ldi transmit_caracter, ' '
    rcall usart_transmit
    rjmp parametro_emergencia
    ret

warning_temp:
    ldi transmit_caracter, ' '
    rcall usart_transmit
    ldi transmit_caracter, 't'
    rcall usart_transmit
    ldi transmit_caracter, 'e'
    rcall usart_transmit
    ldi transmit_caracter, 'm'
    rcall usart_transmit
    ldi transmit_caracter, 'p'
    rcall usart_transmit
    ldi transmit_caracter, 'e'
    rcall usart_transmit
    ldi transmit_caracter, 'r'
    rcall usart_transmit
    ldi transmit_caracter, 'a'
    rcall usart_transmit
    ldi transmit_caracter, 't'
    rcall usart_transmit
    ldi transmit_caracter, 'u'
    rcall usart_transmit
    ldi transmit_caracter, 'r'
    rcall usart_transmit
    ldi transmit_caracter, 'a'
    rcall usart_transmit
    ldi transmit_caracter, ' '
    rcall usart_transmit
    rjmp parametro_emergencia
    ret

lcd_emergencia_btn:
    rcall lcd_clear
    ldi lcd_col, 3      
    rcall lcd_lin0_col
    ldi lcd_caracter, 'E'
    rcall lcd_write_caracter
    ldi lcd_caracter, 'M'
    rcall lcd_write_caracter
    ldi lcd_caracter, 'E'
    rcall lcd_write_caracter
    ldi lcd_caracter, 'R'
    rcall lcd_write_caracter
    ldi lcd_caracter, 'G'
    rcall lcd_write_caracter
    ldi lcd_caracter, 'E'
    rcall lcd_write_caracter
    ldi lcd_caracter, 'N'
    rcall lcd_write_caracter
    ldi lcd_caracter, 'C'
    rcall lcd_write_caracter
    ldi lcd_caracter, 'I'
    rcall lcd_write_caracter
    ldi lcd_caracter, 'A'
    rcall lcd_write_caracter
    ldi lcd_col, 4         
    rcall lcd_lin1_col
    ldi lcd_caracter, 'A'
    rcall lcd_write_caracter
    ldi lcd_caracter, 'C'
    rcall lcd_write_caracter
    ldi lcd_caracter, 'I'
    rcall lcd_write_caracter
    ldi lcd_caracter, 'O'
    rcall lcd_write_caracter
    ldi lcd_caracter, 'N'
    rcall lcd_write_caracter
    ldi lcd_caracter, 'A'
    rcall lcd_write_caracter
    ldi lcd_caracter, 'D'
    rcall lcd_write_caracter
    ldi lcd_caracter, 'A'
    rcall lcd_write_caracter
    ret

lcd_emergencia_temp:
    rcall lcd_clear
    ldi lcd_col, 0      
    rcall lcd_lin0_col
    ldi lcd_caracter, 'B'
    rcall lcd_write_caracter
    ldi lcd_caracter, 'O'
    rcall lcd_write_caracter
    ldi lcd_caracter, 'T'
    rcall lcd_write_caracter
    ldi lcd_caracter, 'A'
    rcall lcd_write_caracter
    ldi lcd_caracter, 'O'
    rcall lcd_write_caracter
    ret

lcd_pwm: 
	rcall lcd_clear
    ldi lcd_col,0
    rcall lcd_lin0_col
    ldi lcd_caracter, 'V'
    rcall lcd_write_caracter
    ldi lcd_caracter, 'A'
    rcall lcd_write_caracter
    ldi lcd_caracter, 'L'
    rcall lcd_write_caracter
    ldi lcd_caracter, 'O'
    rcall lcd_write_caracter
    ldi lcd_caracter, 'R'
    rcall lcd_write_caracter
    ldi lcd_caracter, ' '
    rcall lcd_write_caracter
    ldi lcd_caracter, 'P'
    rcall lcd_write_caracter
    ldi lcd_caracter, 'W'
    rcall lcd_write_caracter
    ldi lcd_caracter, 'M'
    rcall lcd_write_caracter
    ldi lcd_caracter, ':'
    rcall lcd_write_caracter
    ldi lcd_caracter, ' '
    rcall lcd_write_caracter
    rcall lcd_lin0_col
    mov lcd_number, adc_value 
    rcall lcd_write_number
    ret

timr0: 
    push aux
    in aux, SREG
    push aux
    ldi aux, 100 
    out TCNT0, aux
    rcall ligar_motor
    rcall verifica_btn_emergencia
    rcall corrente
    rcall temperatura
    lds cont, contador_seg_memory
    inc cont
    sts contador_seg_memory, cont
    cpi cont, 100
    brsh segundo
    pop aux
    out SREG, aux
    pop aux
    reti

    segundo:
        ;rcall lcd_pwm ;não funciona e não tem porque 
        ldi cont, 0
        sts contador_seg_memory, cont
        lds cont, contador_min_memory
        inc cont
        sts contador_min_memory, cont
        cpi cont, 60
        brsh minuto
        pop aux
        out SREG, aux
        pop aux
        reti
        minuto:
            pop aux
            out SREG, aux
            pop aux
            reti