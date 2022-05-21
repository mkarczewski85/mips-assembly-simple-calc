#-----------------------------------------------------------------------------------------------------------#
# Program do dodawania 5 liczb ca³kowitych wprowadzanych przez u¿ytkownika.
# Uwagi:
#   1) logika programu opiera siê na dwóch "pêtlach": jedna wprowadza wartoœci do pamiêci; druga wyœwietla
#      sk³adniki dodawania oraz jego wynik, np. 2 + 3 + 4 + 5 + 6 = 20
#   2) iteracja po "tablicy" odbywa siê przy wykorzystaniu offsetu ustalanego na podstawie przesuniêcia
#      bitowego w lewo o 2 wzglêdem wartoœci iteratora, czyli inaczej offset = iterator * 4 
#      co w praktyce stanowi wielokrotnoœæ 4 bajtów
#
# Autor: Maciej Karczewski
#-----------------------------------------------------------------------------------------------------------#

.data
x:		.word 0,0,0,0,0 # inicjalizacja "tablicy" dla 5 wartoœci w pamiêci
iterator:	.word 0 # iterator
size:		.word 4 # rozmiar "tablicy"

head:		.asciiz "Sumator 5 liczb.\n"
prompt:		.asciiz "Wprowadz liczbe calkowita: "
result:		.asciiz "Wynik dodawania: "
plus_sign:	.asciiz " + "
equal_sign:	.asciiz " = "

.text
main:
    # wyœwietl nazwê programu (head)
    li $v0, 4
    la $a0, head
    syscall 
    
    # przygotuj "pêtlê"
    la $t0, x # za³aduj adres pocz¹tkowy "tablicy" do rej. $t0
    lw $t1, iterator # za³aduj wartoœæ iteratora do rej. $t1
    lw $t2, size # za³aduj wartoœæ rozmiaru "tablicy" do rej. $t2

# "pêtla" wprowadzania dancych    
input_loop:
    bgt $t1, $t2, show_result # jeœli iterator > size przeskocz do show_result
    
    li $v0, 4 # za³adowanie numeru uslugi (4 - wyœwietl zmienn¹ tekstow¹)
    la $a0, prompt # za³adowanie adresu zmiennej tekstowej prompt do rej. $a0
    syscall # wyœwietl
    
    sll $t3, $t1, 2 # przesuniêcie bitowe o 2, czyli $t3 = iterator * 4 ($t3 to nasz offset)
    addu $t3, $t3, $t0 # adres "tablicy" z $t0 zwiêksz o offset z $t3 ($t3 = $t3 + $t0)
    
    li $v0, 5 # za³adowanie numeru us³ugi (5 - wyprowadzenie z konsoli tekstu ) do rej. $v0
    syscall # wprowadŸ liczbê ca³kwit¹

    sw $v0, 0($t3) # zapisz wprowadzon¹ wartoœæ do pamiêci, pod adresem z rej. $t3
    addi $t1, $t1, 1 # inkrementuj iterator
    j input_loop # kontynuuj "pêtlê"
    
show_result:
    li $v0, 4 # za³adowanie numeru uslugi (4 - wyœwietl zmienn¹ tekstow¹)
    la $a0, result # za³adowanie adresu zmiennej tekstowej result do rej. $a0
    syscall # wyœwietl
    
    # resetuj "pêtlê"
    la $t0, x
    lw $t1, iterator
    lw $t2, size
    
output_loop:
    bgt $t1, $t2, print_sum # jeœli iterator > size przeskocz do print_sum
    
    sll $t3, $t1, 2 # przesuniêcie bitowe o 2, czyli $t3 = iterator * 4 ($t3 to nasz offset)
    addu $t3, $t3, $t0 # adres "tablicy" z $t0 zwiêksz o offset z $t3 ($t3 = $t3 + $t0)
    
    lw $t6, 0($t3) # za³aduj z pamiêci wartoœæ pod adresem z rej. $t3
    addu $s7, $s7, $t6 # dodawaj do siebie kolejne wartoœci ³adowane do rej. $t6 w ramach rej. $s7 ($s7 = $s7 + $t6)
    
    addi $t1, $t1, 1 # inkrementuj iterator
    
    li $v0,1 # za³adowanie uslugi - wyœwietl integer
    move $a0, $t6 # kopiowanie wartoœci sumy do rejestru $a0 (kolejne sk³adniki dodawania)
    syscall # wyœwietl sk³adnik dodawania
    
    ble $t1, $t2, print_plus_sign # jeœli iterator <= size dopisz znak '+' po liczbie
    
    j output_loop # kontynuuj "pêtlê"
    
print_plus_sign:
    li $v0, 4 # za³adowanie numeru uslugi (4 - wyœwietl zmienn¹ tekstow¹)
    la $a0, plus_sign # za³adowanie adresu zmiennej tekstowej plus_sign do rej. $a0
    syscall # wyœwietl
    j output_loop # wróæ do "pêtli" output_loop 
    
print_sum:
    li $v0, 4 # za³adowanie numeru uslugi (4 - wyœwietl zmienn¹ tekstow¹)
    la $a0, equal_sign # za³adowanie adresu zmiennej tekstowej equal_sign do rej. $a0
    syscall # wyœwietl
    
    li $v0,1 # za³adowanie uslugi - wyœwietl integer
    move $a0, $s7 # kopiowanie wartoœci sumy do rejestru $a0
    syscall # wyœwietl wynik dodawania

exit:
    li $v0,10 # wyjœcie z programu
    syscall
