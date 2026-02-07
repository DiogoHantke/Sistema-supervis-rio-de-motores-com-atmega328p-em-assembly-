# Sistema Supervisório de Motores – ATmega328P (Assembly)

![Banner do Projeto](link_da_sua_imagem_aqui.png)

> Projeto didático de sistemas embarcados com ATmega328P, desenvolvido em Assembly para estudo avançado de microcontroladores e controle de motores elétricos em tempo real.

---

## Sumário
- [Descrição Técnica](#descrição-técnica)  
- [Funcionalidades do Projeto](#funcionalidades-do-projeto)  
- [Modos de Operação](#modos-de-operação)  
- [Arquitetura do Sistema](#arquitetura-do-sistema)  
- [Funcionalidades do ATmega328P](#funcionalidades-do-atmega328p)  
- [Esquemas Eletrônicos](#esquemas-eletrônicos)  
- [Projeto Montado](#projeto-montado)  
- [Exemplos Visuais](#exemplos-visuais)  
- [Como Executar](#como-executar)  
- [Licença](#licença)

---

## Descrição Técnica
Este projeto é puramente didático, criado para consolidar conhecimento da disciplina de microcontroladores no curso de Engenharia Mecatrônica.  

O sistema implementa um controle supervisório de motor elétrico, com:  
- Monitoramento em tempo real de temperatura, corrente e rotação do motor;  
- Proteção automática por desligamento quando parâmetros críticos são atingidos;  
- Menus interativos para configuração de limites, soft start e armazenamento de parâmetros;  
- Programação em Assembly explorando a arquitetura interna do ATmega328P, incluindo timers, ADC, PWM, UART, EEPROM e multiplexação de pinos.

---

## Funcionalidades do Projeto
- Monitoramento de temperatura, corrente e rotação do motor em tempo real.  
- Desligamento automático ao atingir níveis críticos.  
- Configuração de parâmetros via menus interativos: limites, tempo de rampa, frequência PWM.  
- Implementação de soft start para controle gradual do motor.  
- Armazenamento de parâmetros em memória interna para persistência entre reinicializações.

---

## Modos de Operação

### Menu Principal
- Modo normal de operação  
- Modo normal com soft start  
- Modo salvar parâmetros  

### Modo Normal
- Definir limite de temperatura  
- Definir limite de corrente  
- Definir frequência do PWM  

### Modo Normal com Soft Start
- Definir tempo de rampa  
- Definir PWM máximo da rampa  

### Menu Salvar Parâmetros
- Definir valores de parâmetros a serem salvos  
- Selecionar local de memória  

---

## Arquitetura do Sistema
- Microcontrolador: ATmega328P (Arduino)  
- Sensores: Temperatura e corrente analógicos  
- Controle: PWM para acionamento do motor  
- Interface: Display LCD 16x2 para menus e status do sistema  
- Software: Programação em Assembly com timers, ADC, UART, EEPROM e multiplexação de pinos  

---

## Funcionalidades do ATmega328P

Este projeto explora diversos recursos do ATmega328P:  

- Display LCD 16x2: Exibe menus, parâmetros e status em tempo real.  
- Menus configuráveis: Permite alterações de valores críticos (tempo, limites, PWM).  
- Temporização com interrupções: Uso de Timers 0, 1 e 2 para soft start, PWM e leitura periódica de sensores.  
- Saída PWM: Controle de velocidade do motor e soft start.  
- Leitura analógica (ADC): Sensores de corrente, temperatura e potenciómetros.  
- Entradas analógicas com potenciómetros: Ajuste manual de parâmetros.  
- Comunicação UART (Serial): Impressão de etapas do processo e status do sistema.  
- EEPROM: Registro persistente de ajustes e parâmetros.  
- Multiplexação de pinos: Otimização do uso de portas do microcontrolador para múltiplas funções simultâneas.

Essa integração permite consolidar conhecimentos em controle de motores, leitura de sensores, temporização, PWM e programação de baixo nível.

---

## Esquemas Eletrônicos

O projeto inclui esquemas detalhados para facilitar o entendimento e a montagem do circuito:  

### Diagrama do Circuito Principal
![Esquema do Circuito Principal](link_do_esquema_principal.png)

> Substitua os links pelas imagens dos esquemas reais geradas em software CAD, Fritzing ou KiCad.

---

## Projeto Montado

Aqui você pode mostrar o hardware funcionando:

![Foto do Projeto Montado](link_da_sua_imagem_fisica_aqui.jpg)

Sistema montado com ATmega328P, sensores de corrente/temperatura, motor de teste e display LCD.

---

## Exemplos Visuais

### Interface de Menus
![GIF de Funcionamento](link_do_seu_gif_aqui.gif)

### Medições e Controle
![Imagem de Exemplo](link_da_sua_imagem_aqui.png)

---

## Como Executar
1. Conecte o microcontrolador ATmega328P ao motor e sensores.  
2. Compile e carregue o firmware em Assembly usando AVR Studio ou Atmel Studio.  
3. Ligue o sistema e navegue pelos menus no display LCD.  
4. Ajuste limites de temperatura, corrente e parâmetros PWM conforme necessário.  
5. Teste a funcionalidade de soft start e desligamento automático.

---

## Licença
Projeto didático, aberto para estudo e aprendizado, sem fins comerciais.  
Sinta-se livre para modificar e explorar para fins acadêmicos.

---

Desenvolvido para Engenharia Mecatrônica com foco em controle de motores, leitura de sensores e programação de microcontroladores de baixo nível.
