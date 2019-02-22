dias_nos_meses = {"janeiro": 31, "fevereiro": 28, "marco" :31, "abril": 30, "maio": 31, "junho": 30, "julho": 31, "agosto": 31, "setembro": 30, "outubro": 31, "novembro": 30, "dezembro": 31}
dias_nos_meses_bissex = {"janeiro": 31, "fevereiro": 29, "marco" :31, "abril": 30, "maio": 31, "junho": 30, "julho": 31, "agosto": 31, "setembro": 30, "outubro": 31, "novembro": 30, "dezembro": 31}
contador_ano_bissex = 0
dias_na_semana = ['segunda', 'terca', 'quarta', 'quinta', 'sexta', 'sabado', 'domingo']
contador_dia_mes = 1
contador_dias_uteis = 0

dia_da_semana = input("Qual dia da semana comeca o mes? (segunda, terca, quarta, ...) - sem acentos\n")
mes_atual = input("Em qual mes estamos? (janeiro, fevereiro, marco, abril, ... ) - sem acentos\n")
ano_atual = int(input("Em que ano estamos? (2018, 2019, ...)\n"))
converte_dia_numero = {"segunda": 0, "terca": 1, "quarta": 2, "quinta": 3, "sexta": 4, "sabado": 5, "domingo": 6}

contador_ano_bissex = ano_atual % 4 # se contador_ano_bissex == 0, eh ano bissex

if contador_ano_bissex == 0:
    dias_nos_meses_ = dias_nos_meses_bissex
else:
    dias_nos_meses_ = dias_nos_meses


valor_inicial = converte_dia_numero[dia_da_semana]

for dia in range(1, dias_nos_meses_[mes_atual]+1):
    if valor_inicial < 5:
        contador_dias_uteis += 1
    
    valor_inicial += 1
    valor_inicial = valor_inicial % 7


print("O mes " + mes_atual + " possui " + str(contador_dias_uteis) + " dias uteis")
