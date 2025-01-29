# IQuadras

### Curso: Tecnologia em Sistemas para Internet  
**Disciplina:** Programação Distribuída  
**Docente:** Gustavo Wagner Diniz Mendes  

---

## Descrição do Problema e Solução

O **IQuadras** é uma plataforma desenvolvida para facilitar o agendamento de quadras esportivas. Foi identificado que proprietários e usuários enfrentam dificuldades em gerenciar reservas, principalmente em relação à disponibilidade em tempo real, notificações e otimização de horários.

### Solução Proposta

A solução envolve transformar o sistema em uma **arquitetura baseada em sistemas distribuídos**. Os módulos serão independentes (**microsserviços**) e se comunicarão usando tecnologias modernas como **gRPC**, **RabbitMQ** e **Redis**.

O sistema irá:
- Facilitar o agendamento e gerenciamento de quadras esportivas em tempo real;
- Melhorar escalabilidade e resiliência através de arquitetura distribuída;
- Otimizar performance utilizando cache distribuído e filas de mensagens;
- Garantir alta disponibilidade e tolerância a falhas por meio de replicação de dados e balanceamento de carga.

---

## Divisão Arquitetural

### Microsserviços:

1. **Serviço de Autenticação**
   - Autenticação e autorização de usuários (proprietários e clientes);
   - Comunicação com outros microsserviços via gRPC.

2. **Serviço de Reservas**
   - Gerenciamento de agendamento de quadras (criar, cancelar, modificar);
   - Uso de RabbitMQ para processar solicitações em tempo real.

3. **Serviço de Notificações**
   - Envio de notificações por e-mail e push sobre reservas;
   - RabbitMQ para filas de mensagens assíncronas.

4. **Serviço de Disponibilidade e Cache**
   - Implementado com Redis para armazenar dados temporários (ex.: disponibilidade de quadras);
   - Redução de carga em bancos de dados relacionais.

5. **Serviço de Pagamentos**
   - Gerenciamento de transações financeiras;
   - Transações distribuídas para consistência dos dados.

---

## Infraestrutura de Nuvem

- **Hospedagem:** AWS (ECS, S3) e Heroku para módulos menores.
- **Banco de Dados:**
  - **Firestore:** Para dados não relacionais.
  - **PostgreSQL:** Para dados relacionais.

---

## Tecnologias Usadas

- **Comunicação entre módulos:** gRPC para baixo tempo de resposta.
- **Filas de mensagens:** RabbitMQ para comunicação assíncrona entre serviços.
- **Cache:** Redis para melhorar a performance de leitura.
- **Armazenamento em nuvem:** Firestore para alta escalabilidade.
- **Hospedagem e Deploy:** AWS e Heroku para garantir disponibilidade e escalabilidade.

---

## Algoritmos e Temas de Sistemas Distribuídos

1. **Transações Distribuídas:**  
   Garantia de consistência em operações financeiras no serviço de pagamentos.

2. **Replicação de Dados:**  
   Utilização de replicação no Firestore para alta disponibilidade.

3. **Tolerância a Falhas:**  
   Estratégias de retries e failovers para lidar com falhas temporárias.

4. **Coordenação e Sincronização:**  
   Sistema de lock distribuído com Redis para consistência nas reservas.

---

## Plano de Entrega

### **Etapa 1:**
- Criação do documento inicial com descrição detalhada do projeto e arquitetura.
- Diagrama de comunicação entre módulos (imagem a ser anexada).

### **Etapa 2:**
- Desenvolvimento dos microsserviços básicos.
- Configuração de filas de mensagens e comunicação via gRPC.
- Implementação de cache com Redis.

### **Etapa 3:**
- Integração com serviços externos (notificações e pagamentos).
- Testes de performance e escalabilidade.

### **Etapa 4:**
- Apresentação da aplicação e análise de performance (uso de CPU, memória e latência).

---

## Divisão de Tarefas no Grupo

- **Yuri Souza:** Desenvolvimento do serviço de autenticação e integração com gRPC.  
- **Manoel Pedro:** Implementação do serviço de reservas e filas de mensagens.  
- **Geraldo Neto:** Configuração do serviço de notificações e integração com Redis.  
- **Luiz Manoel:** Gerenciamento do serviço de pagamentos e transações distribuídas.

---
