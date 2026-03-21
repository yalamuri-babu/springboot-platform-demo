{{- define "springboot-app.name" -}}
springboot-app
{{- end }}

{{- define "springboot-app.fullname" -}}
springboot-app
{{- end }}

{{- define "springboot-app.selectorLabels" -}}
app.kubernetes.io/name: {{ include "springboot-app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}