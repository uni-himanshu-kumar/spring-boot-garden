{{/*
Expand the name of the chart.
*/}}
{{- define "hello-world-java.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "hello-world-java.fullname" -}}
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
{{- define "hello-world-java.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "hello-world-java.labels" -}}
helm.sh/chart: {{ include "hello-world-java.chart" . }}
{{ include "hello-world-java.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "hello-world-java.selectorLabels" -}}
app.kubernetes.io/name: {{ include "hello-world-java.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{ include "hello-world-java.datadog.labels" . }}
{{- end }}

{{/*
Datadog labels
*/}}
{{- define "hello-world-java.datadog.labels" -}}
tags.datadoghq.com/env: {{ .Values.datadog.env | required "datadog.env required" }}
tags.datadoghq.com/service: {{ include "hello-world-java.fullname" . }}
{{- end }}


{{/*
Create the name of the service account to use
*/}}
{{- define "hello-world-java.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "hello-world-java.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
TLS on Ingress
*/}}
{{- define "hello-world-java.ingress.annotations" -}}
{{- if ne .Values.ingress.domainName "localhost" -}}
ingress.kubernetes.io/force-ssl-redirect: "true"
{{- end }}
{{- end }}

{{- define "hello-world-java.ingress.tls" -}}
{{- if ne .Values.ingress.domainName "localhost" -}}
tls:
  - hosts:
      - {{ .Values.ingress.hostName }}.{{ .Values.ingress.domainName }}
    secretName: {{ .Values.ingress.certName }}
{{- end }}
{{- end }}
