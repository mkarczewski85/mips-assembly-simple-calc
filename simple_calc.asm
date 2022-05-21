#-----------------------------------------------------------------------------------------------------------#
# Program do dodawania 5 liczb ca�kowitych wprowadzanych przez u�ytkownika.
# Uwagi:
#   1) logika programu opiera si� na dw�ch "p�tlach": jedna wprowadza warto�ci do pami�ci; druga wy�wietla
#      sk�adniki dodawania oraz jego wynik, np. 2 + 3 + 4 + 5 + 6 = 20
#   2) iteracja po "tablicy" odbywa si� przy wykorzystaniu offsetu ustalanego na podstawie przesuni�cia
#      bitowego w lewo o 2 wzgl�dem warto�ci iteratora, czyli inaczej offset = iterator * 4 
#      co w praktyce stanowi wielokrotno�� 4 bajt�w
#
# Autor: Maciej Karczewski
#-----------------------------------------------------------------------------------------------------------#

.data
x:		.word 0,0,0,0,0 # inicjalizacja "tablicy" dla 5 warto�ci w pami�ci
iterator:	.word 0 # iterator
size:		.word 4 # rozmiar "tablicy"

head:		.asciiz "Sumator 5 liczb.\n"
prompt:		.asciiz "Wprowadz liczbe calkowita: "
result:		.asciiz "Wynik dodawania: "
plus_sign:	.asciiz " + "
equal_sign:	.asciiz " = "

.text
main:
    # wy�wietl nazw� programu (head)
    li $v0, 4
    la $a0, head
    syscall 
    
    # przygotuj "p�tl�"
    la $t0, x # za�aduj adres pocz�tkowy "tablicy" do rej. $t0
    lw $t1, iterator # za�aduj warto�� iteratora do rej. $t1
    lw $t2, size # za�aduj warto�� rozmiaru "tablicy" do rej. $t2

# "p�tla" wprowadzania dancych    
input_loop:
    bgt $t1, $t2, show_result # je�li iterator > size przeskocz do show_result
    
    li $v0, 4 # za�adowanie numeru uslugi (4 - wy�wietl zmienn� tekstow�)
    la $a0, prompt # za�adowanie adresu zmiennej tekstowej prompt do rej. $a0
    syscall # wy�wietl
    
    sll $t3, $t1, 2 # przesuni�cie bitowe o 2, czyli $t3 = iterator * 4 ($t3 to nasz offset)
    addu $t3, $t3, $t0 # adres "tablicy" z $t0 zwi�ksz o offset z $t3 ($t3 = $t3 + $t0)
    
    li $v0, 5 # za�adowanie numeru us�ugi (5 - wyprowadzenie z konsoli tekstu ) do rej. $v0
    syscall # wprowad� liczb� ca�kwit�

    sw $v0, 0($t3) # zapisz wprowadzon� warto�� do pami�ci, pod adresem z rej. $t3
    addi $t1, $t1, 1 # inkrementuj iterator
    j input_loop # kontynuuj "p�tl�"
    
show_result:
    li $v0, 4 # za�adowanie numeru uslugi (4 - wy�wietl zmienn� tekstow�)
    la $a0, result # za�adowanie adresu zmiennej tekstowej result do rej. $a0
    syscall # wy�wietl
    
    # resetuj "p�tl�"
    la $t0, x
    lw $t1, iterator
    lw $t2, size
    
output_loop:
    bgt $t1, $t2, print_sum # je�li iterator > size przeskocz do print_sum
    
    sll $t3, $t1, 2 # przesuni�cie bitowe o 2, czyli $t3 = iterator * 4 ($t3 to nasz offset)
    addu $t3, $t3, $t0 # adres "tablicy" z $t0 zwi�ksz o offset z $t3 ($t3 = $t3 + $t0)
    
    lw $t6, 0($t3) # za�aduj z pami�ci warto�� pod adresem z rej. $t3
    addu $s7, $s7, $t6 # dodawaj do siebie kolejne warto�ci �adowane do rej. $t6 w ramach rej. $s7 ($s7 = $s7 + $t6)
    
    addi $t1, $t1, 1 # inkrementuj iterator
    
    li $v0,1 # za�adowanie uslugi - wy�wietl integer
    move $a0, $t6 # kopiowanie warto�ci sumy do rejestru $a0 (kolejne sk�adniki dodawania)
    syscall # wy�wietl sk�adnik dodawania
    
    ble $t1, $t2, print_plus_sign # je�li iterator <= size dopisz znak '+' po liczbie
    
    j output_loop # kontynuuj "p�tl�"
    
print_plus_sign:
    li $v0, 4 # za�adowanie numeru uslugi (4 - wy�wietl zmienn� tekstow�)
    la $a0, plus_sign # za�adowanie adresu zmiennej tekstowej plus_sign do rej. $a0
    syscall # wy�wietl
    j output_loop # wr�� do "p�tli" output_loop 
    
print_sum:
    li $v0, 4 # za�adowanie numeru uslugi (4 - wy�wietl zmienn� tekstow�)
    la $a0, equal_sign # za�adowanie adresu zmiennej tekstowej equal_sign do rej. $a0
    syscall # wy�wietl
    
    li $v0,1 # za�adowanie uslugi - wy�wietl integer
    move $a0, $s7 # kopiowanie warto�ci sumy do rejestru $a0
    syscall # wy�wietl wynik dodawania

exit:
    li $v0,10 # wyj�cie z programu
    syscall
