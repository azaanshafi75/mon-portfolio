param(
    [string]$RepoRoot = (Get-Location).Path
)

$ErrorActionPreference = 'Stop'

$PackageRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = (Resolve-Path $RepoRoot).Path

Write-Host "Portfolio : $RepoRoot" -ForegroundColor Cyan
Write-Host "Package   : $PackageRoot" -ForegroundColor Cyan

$required = @(
    (Join-Path $RepoRoot 'projets-scolaires.html'),
    (Join-Path $RepoRoot 'assets/css/style.css'),
    (Join-Path $RepoRoot 'projets')
)
foreach ($path in $required) {
    if (-not (Test-Path $path)) { throw "Le dossier courant ne semble pas être la racine du portfolio : élément introuvable -> $path" }
}

# 1) Copier la page projet, le PDF et les captures.
New-Item -ItemType Directory -Force -Path (Join-Path $RepoRoot 'assets/docs') | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $RepoRoot 'assets/images/projects/glpi') | Out-Null

Copy-Item (Join-Path $PackageRoot 'projets/glpi-gestion-parc-helpdesk.html') (Join-Path $RepoRoot 'projets/glpi-gestion-parc-helpdesk.html') -Force
Copy-Item (Join-Path $PackageRoot 'assets/docs/Projet_GLPI_Gestion_Parc_Helpdesk.pdf') (Join-Path $RepoRoot 'assets/docs/Projet_GLPI_Gestion_Parc_Helpdesk.pdf') -Force
Copy-Item (Join-Path $PackageRoot 'assets/images/projects/glpi/*') (Join-Path $RepoRoot 'assets/images/projects/glpi') -Force

# 2) Ajouter la carte 06 à projets-scolaires.html, sans doublon.
$projectsFile = Join-Path $RepoRoot 'projets-scolaires.html'
$html = Get-Content -Raw -Encoding UTF8 $projectsFile

if ($html -notmatch 'glpi-gestion-parc-helpdesk\.html') {
$card = @'

<article class="card project-card" data-reveal>
<div class="project-thumb"><img src="assets/images/projects/glpi/00-architecture-glpi.png" alt="Architecture du laboratoire GLPI de gestion de parc et Helpdesk" loading="lazy" width="960" height="600"></div>
<div class="project-card-body">
<div class="card-top"><span class="badge">ITSM & support</span><span class="card-number">06</span></div>
<div style="margin-bottom:.9rem"><span class="project-status">Projet terminé</span></div>
<h3><a class="card-link" href="projets/glpi-gestion-parc-helpdesk.html">Gestion de parc informatique & support IT avec GLPI</a></h3>
<p>Laboratoire GLPI 11 orienté gestion de parc et Helpdesk : inventaire natif, Self-Service, catégories ITIL, SLA, traitement d’incident, base de connaissances, MFA, reporting et sauvegarde SMB automatisée.</p>
<div class="tags"><span class="tag">GLPI 11</span><span class="tag">Agent 1.16</span><span class="tag">ITIL / SLA</span><span class="tag">MFA</span><span class="tag">Samba / SMB</span></div>
<div class="project-actions"><a class="button button-primary" href="projets/glpi-gestion-parc-helpdesk.html">Voir le projet →</a><a class="button button-secondary" href="assets/docs/Projet_GLPI_Gestion_Parc_Helpdesk.pdf" target="_blank" rel="noopener">Documentation PDF</a></div>
</div>
</article>
'@

    $marker = '<div class="projects-note">'
    $index = $html.IndexOf($marker)
    if ($index -lt 0) { throw 'Marqueur projects-note introuvable dans projets-scolaires.html.' }

    # La div immédiatement avant projects-note ferme project-grid.
    $before = $html.Substring(0, $index)
    $after = $html.Substring($index)
    $closeGridIndex = $before.LastIndexOf('</div>')
    if ($closeGridIndex -lt 0) { throw 'Fermeture de project-grid introuvable.' }

    $insertAt = $closeGridIndex
    $html = $before.Substring(0, $insertAt) + $card + "`n" + $before.Substring($insertAt) + $after
    Set-Content -Path $projectsFile -Value $html -Encoding UTF8
    Write-Host 'Carte GLPI ajoutée à projets-scolaires.html.' -ForegroundColor Green
} else {
    Write-Host 'La carte GLPI existe déjà dans projets-scolaires.html : aucune duplication.' -ForegroundColor Yellow
}

Write-Host ''
Write-Host 'Fichiers prêts :' -ForegroundColor Green
Write-Host '  projets/glpi-gestion-parc-helpdesk.html'
Write-Host '  assets/docs/Projet_GLPI_Gestion_Parc_Helpdesk.pdf'
Write-Host '  assets/images/projects/glpi/'
Write-Host '  projets-scolaires.html (carte 06 ajoutée)'
Write-Host ''
Write-Host 'Étape suivante : ouvrez la page localement, puis git add / commit / push.' -ForegroundColor Cyan
