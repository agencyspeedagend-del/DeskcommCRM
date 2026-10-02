# Patch local: page_id nas conversões da Meta (v1.69.0)

A Meta recusa o `Purchase` de clique-para-WhatsApp (`action_source: business_messaging`) sem
`page_id` ou `whatsapp_business_account_id` em `user_data` (code 100, subcode 2804116).
A v1.69.0 não envia nenhum dos dois. Issue: https://github.com/melgarafael/DeskcommCRM/issues/2098

Este patch, aplicado sobre as imagens oficiais da v1.69.0:
- envia `user_data.page_id` com o valor da variável de ambiente `META_PAGE_ID`;
- faz o hash do telefone (`ph`) só com dígitos.

Só serve para a **v1.69.0**: o build falha de propósito se o código não for o esperado.
Quando a issue for resolvida numa versão oficial, este patch deixa de ser necessário.

## Aplicar (na VPS, com o CRM instalado em /root/DeskcommCRM)

```sh
cd patches-locais/meta-page-id
docker build -f Dockerfile.app -t deskcommcrm:1.69.0-pageid .
docker build -f Dockerfile.worker -t deskcomm-worker:1.69.0-pageid .

cd /root/DeskcommCRM
cp -p .env .env.bak-antes-pageid
# no .env:
#   APP_IMAGE=deskcommcrm:1.69.0-pageid
#   WORKER_IMAGE=deskcomm-worker:1.69.0-pageid
#   META_PAGE_ID=<ID da Página do Facebook do cliente>
docker compose -f docker-compose.prod.yml up -d app worker
```

O ID da Página fica em: Página do Facebook → Sobre → Transparência da Página.
Não confundir com o ID do conjunto de dados (pixel).

## Desfazer

```sh
cd /root/DeskcommCRM
cp -p .env.bak-antes-pageid .env
docker compose -f docker-compose.prod.yml up -d app worker
```

## Observações

- Teste com um clique real no anúncio (no feed); a pré-visualização do Gerenciador de Anúncios não gera `ctwa_clid`.
- Com `test_event_code`, eventos de WhatsApp apareceram na Visão geral do conjunto de dados como eventos normais.
  Não faça testes com compras numa conta em produção.
