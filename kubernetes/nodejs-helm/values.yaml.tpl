env:
%{ for k,v in entrypoint.env ~}
- name: ${k}
  value: "${v}"
%{ endfor ~}
