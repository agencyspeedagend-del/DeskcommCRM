# Patch local sobre a v1.69.0: envia page_id (META_PAGE_ID) e telefone só com dígitos à Meta.
FROM ghcr.io/melgarafael/deskcommcrm:1.69.0
USER root
RUN F=/app/.next/server/chunks/_1vghujs._.js \
 && grep -q 'let l={ctwa_clid:a.cliqueDeOrigem};' $F \
 && grep -q '(t=a.telefone,' $F \
 && sed -i 's/let l={ctwa_clid:a.cliqueDeOrigem};/let l={ctwa_clid:a.cliqueDeOrigem};process.env.META_PAGE_ID\&\&(l.page_id=process.env.META_PAGE_ID);/' $F \
 && sed -i 's/(t=a.telefone,/(t=a.telefone.replace(\/\\D\/g,""),/' $F \
 && grep -q 'l.page_id=process.env.META_PAGE_ID' $F \
 && grep -q 'a.telefone.replace(/\\D/g,"")' $F
USER nextjs
