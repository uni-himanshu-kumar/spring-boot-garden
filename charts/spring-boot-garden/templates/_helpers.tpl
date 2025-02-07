{{/*
Expand the name of the chart.
*/}}
{{- define "spring-boot-garden.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "spring-boot-garden.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "spring-boot-garden.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "spring-boot-garden.labels" -}}
helm.sh/chart: {{ include "spring-boot-garden.chart" . }}
{{ include "spring-boot-garden.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "spring-boot-garden.selectorLabels" -}}
app.kubernetes.io/name: {{ include "spring-boot-garden.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{ include "spring-boot-garden.datadog.labels" . }}
{{- end }}

{{/*
Datadog labels
*/}}
{{- define "spring-boot-garden.datadog.labels" -}}
tags.datadoghq.com/env: {{ .Values.datadog.env | required "datadog.env required" }}
tags.datadoghq.com/service: {{ include "spring-boot-garden.fullname" . }}
{{- end }}


{{/*
Create the name of the service account to use
*/}}
{{- define "spring-boot-garden.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "spring-boot-garden.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
TLS on Ingress
*/}}
{{- define "spring-boot-garden.ingress.annotations" -}}
{{- if ne .Values.ingress.domainName "localhost" -}}
ingress.kubernetes.io/force-ssl-redirect: "true"
{{- end }}
{{- end }}

{{- define "spring-boot-garden.ingress.tls" -}}
{{- if ne .Values.ingress.domainName "localhost" -}}
tls:
  - hosts:
      - {{ .Values.ingress.hostName }}.{{ .Values.ingress.domainName }}
    secretName: {{ .Values.ingress.certName }}
{{- end }}
{{- end }}
