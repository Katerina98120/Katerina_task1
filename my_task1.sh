#!/bin/bash


#Топ-10 дат по общему количеству скачанных байт

#Количество скачанных байт с каждой из них как число

#Количество скачанных байт с каждой из них как процент от общего количества байт, скачанных за эти даты


FILE_NAME="log.txt"

BYTES=$(sed -r 's/\S* - - \[([^:]*)[^"]*"[^"]*" \S* ([-[0-9]*]*).*/\1\t\2/' $FILE_NAME | grep -v -)


# grep -v - выбирает все строки без "-"


COUNT=$(echo "$BYTES" | awk '{sum += $2} 
END {print sum}')

# awk - суммирует все значения во второй группе


array1=( $(echo "$BYTES" | sort -nrk 1 | awk '{print $1}') )

array2=( $(echo "$BYTES" | sort -nrk 1 | awk '{print $2}') )


# sort -nrk 1 - сортирует в обратном порядке по первой группе 

# awk - сохраняет значения в массив

# array1 - дата; array2 - кол-во байт 

i=$((${#array1[@]} - 1));

# i - размер массива

# Проходим весь массив с конца если встречается одинаковая дата то суммируем количество байт и удаляем значения в 1-ом и 2-ом массива



for (( i; i > 0 ; i-- ))

do

	
	if [ ${array1[i]} = ${array1[i-1]} ]
	
then
		
array2[$i-1]=`expr ${array2[$i]} + ${array2[$i-1]}`;

		unset array1[$i];
	
	unset array2[$i];
	
else continue;

	fi
	
done

# expr суммирует значения 


array1=( $(echo "${array1[@]}" | grep -v null) )

array2=( $(echo "${array2[@]}" | grep -v null) )


# Перезаписываем массивы без пустых ячеек


# Сортировка пузырьком в порядке убывания 

# buff - локальная переменная для обмена 

for (( i=0; i < `expr ${#array2[@]} - 1`; i++ ))
do 
	
for (( g=0; g < `expr ${#array2[@]} - 1 - $i`; g++ ))

		do

			if [[ ${array2[$g]} < ${array2[`expr $g + 1`]} ]]

			then

		buff=${array2[$g]}
	
			array2[$g]=${array2[`expr $g + 1`]}
	
			array2[`expr $g + 1`]=$buff

		
		buff=${array1[$g]}
			
	array1[$g]=${array1[`expr $g + 1`]}
		
		array1[`expr $g + 1`]=$buff
			
fi
				
	
	done
	
done



# Выбираем первые 10 элементов массива

TOP_10=10;

for (( i=0; i < $TOP_10; i++ ))
do

	 p=$(( ${array2[$i]} * 100 / $COUNT ))
	echo "${array1[$i]} - ${array2[$i]} - $p%"

done
