// ==================== UI UTILITIES ====================

// Show/Hide Toast Notifications
function showToast(message, type = 'success') {
    const toast = document.getElementById('toast');
    toast.textContent = message;
    toast.className = `toast show ${type}`;
    
    setTimeout(() => {
        toast.classList.remove('show');
    }, 3000);
}

// Modal Management
function openModal(entity, id = null) {
    const modal = document.getElementById('modal');
    const form = document.getElementById('entity-form');
    
    form.dataset.entity = entity;
    form.dataset.id = id || '';
    
    document.getElementById('modal-title').textContent = 
        id ? `Modifier ${entity}` : `Ajouter ${entity}`;
    
    loadFormFields(entity, id);
    modal.classList.add('active');
}

function closeModal() {
    const modal = document.getElementById('modal');
    modal.classList.remove('active');
    document.getElementById('entity-form').reset();
}

// Close modal when clicking outside
window.onclick = function(event) {
    const modal = document.getElementById('modal');
    if (event.target === modal) {
        closeModal();
    }
}

// Load form fields based on entity
function loadFormFields(entity, id = null) {
    const fieldsContainer = document.getElementById('form-fields');
    fieldsContainer.innerHTML = '';

    const fields = getFieldsForEntity(entity);
    
    fields.forEach(field => {
        const formGroup = document.createElement('div');
        formGroup.className = 'form-group';
        
        formGroup.innerHTML = `
            <label for="${field.name}">${field.label}</label>
            <input 
                type="${field.type}" 
                id="${field.name}" 
                name="${field.name}"
                placeholder="${field.placeholder || ''}"
                ${field.required ? 'required' : ''}
            />
        `;
        
        fieldsContainer.appendChild(formGroup);
    });

    // If editing, load current data
    if (id) {
        loadFormData(entity, id);
    }
}

// Get form fields configuration for each entity
function getFieldsForEntity(entity) {
    const fieldsMap = {
        personnel: [
            { name: 'nom', label: 'Nom *', type: 'text', placeholder: 'Nom', required: true },
            { name: 'prenom', label: 'Prénom *', type: 'text', placeholder: 'Prénom', required: true },
            { name: 'email', label: 'Email *', type: 'email', placeholder: 'email@example.com', required: true },
            { name: 'numeroTelephone', label: 'Téléphone', type: 'tel', placeholder: '+33 6 XX XX XX XX' },
            { name: 'adresse', label: 'Adresse', type: 'text', placeholder: 'Adresse' },
            { name: 'codePostal', label: 'Code Postal', type: 'text', placeholder: '75000' },
            { name: 'ville', label: 'Ville', type: 'text', placeholder: 'Paris' },
            { name: 'niveauEtudeEleve', label: 'Niveau d\'étude', type: 'text', placeholder: 'Bac+5' },
            { name: 'dateNaissance', label: 'Date de Naissance', type: 'date' }
        ],
        poste: [
            { name: 'fonction', label: 'Fonction *', type: 'text', placeholder: 'Développeur', required: true },
            { name: 'departement', label: 'Département', type: 'text', placeholder: 'Informatique' },
            { name: 'specialite', label: 'Spécialité', type: 'text', placeholder: 'Backend' },
            { name: 'niveauRequis', label: 'Niveau Requis', type: 'text', placeholder: 'Bac+3' },
            { name: 'description', label: 'Description', type: 'text', placeholder: 'Description du poste' },
            { name: 'nombrePostesDisponibles', label: 'Nombre de Postes', type: 'number', placeholder: '1' },
            { name: 'dureeContratPrevu', label: 'Durée Contrat Prévue (mois)', type: 'number', placeholder: '12' }
        ],
        annonce: [
            { name: 'id_post', label: 'ID Poste *', type: 'number', placeholder: '1', required: true },
            { name: 'datePublication', label: 'Date Publication *', type: 'date', required: true },
            { name: 'dateCloturePostulation', label: 'Date Clôture Postulation *', type: 'date', required: true },
            { name: 'dateClotureAnnonce', label: 'Date Clôture Annonce', type: 'date' },
            { name: 'nombrePostes', label: 'Nombre de Postes', type: 'number', placeholder: '1' },
            { name: 'id_statut', label: 'Statut', type: 'number', placeholder: '1' }
        ],
        candidature: [
            { name: 'id_annonce', label: 'ID Annonce', type: 'number', placeholder: '1' },
            { name: 'id_personnel', label: 'ID Personnel', type: 'number', placeholder: '1' },
            { name: 'dateCandidature', label: 'Date Candidature', type: 'date' },
            { name: 'statut', label: 'Statut', type: 'text', placeholder: 'En cours' },
            { name: 'note', label: 'Note', type: 'number', placeholder: '0-100' }
        ],
        contrat: [
            { name: 'id_personnel', label: 'ID Personnel', type: 'number', placeholder: '1' },
            { name: 'id_poste', label: 'ID Poste', type: 'number', placeholder: '1' },
            { name: 'dateDebut', label: 'Date Début *', type: 'date', required: true },
            { name: 'dateFin', label: 'Date Fin', type: 'date' },
            { name: 'typeContrat', label: 'Type Contrat', type: 'text', placeholder: 'CDI' },
            { name: 'salaire', label: 'Salaire', type: 'number', placeholder: '30000' }
        ]
    };

    return fieldsMap[entity] || [];
}

// Load existing data into form
async function loadFormData(entity, id) {
    try {
        let data;
        
        switch(entity) {
            case 'personnel':
                data = await Personnel.getById(id);
                break;
            case 'poste':
                data = await Poste.getById(id);
                break;
            case 'annonce':
                data = await Annonce.getById(id);
                break;
            case 'candidature':
                data = await Candidature.getById(id);
                break;
            case 'contrat':
                data = await Contrat.getById(id);
                break;
        }

        if (data.success) {
            const record = data.data;
            Object.keys(record).forEach(key => {
                const input = document.querySelector(`[name="${key}"]`);
                if (input) {
                    input.value = record[key] || '';
                }
            });
        }
    } catch (error) {
        console.error('Error loading form data:', error);
    }
}

// Navigation between sections
function navigateTo(section) {
    // Hide all sections
    document.querySelectorAll('.content-section').forEach(s => {
        s.classList.remove('active');
    });

    // Show selected section
    document.getElementById(section).classList.add('active');

    // Update navigation
    document.querySelectorAll('.nav-link').forEach(link => {
        link.classList.remove('active');
    });
    document.querySelector(`[data-section="${section}"]`).classList.add('active');

    // Update page title
    const titles = {
        dashboard: 'Tableau de Bord',
        personnel: 'Gestion du Personnel',
        poste: 'Gestion des Postes',
        annonce: 'Gestion des Annonces',
        candidature: 'Gestion des Candidatures',
        contrat: 'Gestion des Contrats'
    };
    document.getElementById('page-title').textContent = titles[section];

    // Load data
    loadSectionData(section);
}

// Load section data
async function loadSectionData(section) {
    try {
        switch(section) {
            case 'personnel':
                await loadPersonnelTable();
                break;
            case 'poste':
                await loadPosteTable();
                break;
            case 'annonce':
                await loadAnnonceTable();
                break;
            case 'candidature':
                await loadCandidatureTable();
                break;
            case 'contrat':
                await loadContratTable();
                break;
            case 'dashboard':
                await loadDashboard();
                break;
        }
    } catch (error) {
        console.error(`Error loading ${section}:`, error);
        showToast(`Erreur lors du chargement de ${section}`, 'error');
    }
}

// ==================== TABLE LOADERS ====================

async function loadPersonnelTable() {
    try {
        const response = await Personnel.getAll();
        if (response.success) {
            const tbody = document.querySelector('#personnel-table tbody');
            tbody.innerHTML = '';

            response.data.forEach(personnel => {
                tbody.innerHTML += `
                    <tr>
                        <td>${personnel.id_personnel}</td>
                        <td>${personnel.nom}</td>
                        <td>${personnel.prenom}</td>
                        <td>${personnel.email}</td>
                        <td>${personnel.numeroTelephone || '-'}</td>
                        <td>${personnel.ville || '-'}</td>
                        <td>${personnel.niveauEtudeEleve || '-'}</td>
                        <td>
                            <button class="btn btn-warning" onclick="openModal('personnel', ${personnel.id_personnel})">Modifier</button>
                            <button class="btn btn-danger" onclick="deleteEntity('personnel', ${personnel.id_personnel})">Supprimer</button>
                        </td>
                    </tr>
                `;
            });
        }
    } catch (error) {
        console.error('Error loading personnel table:', error);
    }
}

async function loadPosteTable() {
    try {
        const response = await Poste.getAll();
        if (response.success) {
            const tbody = document.querySelector('#poste-table tbody');
            tbody.innerHTML = '';

            response.data.forEach(poste => {
                tbody.innerHTML += `
                    <tr>
                        <td>${poste.id_poste}</td>
                        <td>${poste.fonction}</td>
                        <td>${poste.departement || '-'}</td>
                        <td>${poste.specialite || '-'}</td>
                        <td>${poste.niveauRequis || '-'}</td>
                        <td>${poste.nombrePostesDisponibles}</td>
                        <td>
                            <button class="btn btn-warning" onclick="openModal('poste', ${poste.id_poste})">Modifier</button>
                            <button class="btn btn-danger" onclick="deleteEntity('poste', ${poste.id_poste})">Supprimer</button>
                        </td>
                    </tr>
                `;
            });
        }
    } catch (error) {
        console.error('Error loading poste table:', error);
    }
}

async function loadAnnonceTable() {
    try {
        const response = await Annonce.getAll();
        if (response.success) {
            const tbody = document.querySelector('#annonce-table tbody');
            tbody.innerHTML = '';

            response.data.forEach(annonce => {
                tbody.innerHTML += `
                    <tr>
                        <td>${annonce.id_annonce}</td>
                        <td>${annonce.titre}</td>
                        <td>${annonce.id_poste || '-'}</td>
                        <td><span class="badge ${annonce.actif ? 'active' : 'inactive'}">${annonce.actif ? 'Actif' : 'Inactif'}</span></td>
                        <td>${annonce.datePublication || '-'}</td>
                        <td>
                            <button class="btn btn-warning" onclick="openModal('annonce', ${annonce.id_annonce})">Modifier</button>
                            <button class="btn btn-danger" onclick="deleteEntity('annonce', ${annonce.id_annonce})">Supprimer</button>
                        </td>
                    </tr>
                `;
            });
        }
    } catch (error) {
        console.error('Error loading annonce table:', error);
    }
}

async function loadCandidatureTable() {
    try {
        const response = await Candidature.getAll();
        if (response.success) {
            const tbody = document.querySelector('#candidature-table tbody');
            tbody.innerHTML = '';

            response.data.forEach(candidature => {
                tbody.innerHTML += `
                    <tr>
                        <td>${candidature.id_candidature}</td>
                        <td>${candidature.nomCandidat || '-'}</td>
                        <td>${candidature.id_annonce}</td>
                        <td>${candidature.statut || '-'}</td>
                        <td>${candidature.dateCandidature || '-'}</td>
                        <td>
                            <button class="btn btn-warning" onclick="openModal('candidature', ${candidature.id_candidature})">Modifier</button>
                            <button class="btn btn-danger" onclick="deleteEntity('candidature', ${candidature.id_candidature})">Supprimer</button>
                        </td>
                    </tr>
                `;
            });
        }
    } catch (error) {
        console.error('Error loading candidature table:', error);
    }
}

async function loadContratTable() {
    try {
        const response = await Contrat.getAll();
        if (response.success) {
            const tbody = document.querySelector('#contrat-table tbody');
            tbody.innerHTML = '';

            response.data.forEach(contrat => {
                tbody.innerHTML += `
                    <tr>
                        <td>${contrat.id_contrat}</td>
                        <td>${contrat.nomPersonnel || '-'}</td>
                        <td>${contrat.id_poste || '-'}</td>
                        <td>${contrat.dateDebut || '-'}</td>
                        <td>${contrat.dateFin || '-'}</td>
                        <td>${contrat.typeContrat || '-'}</td>
                        <td>
                            <button class="btn btn-warning" onclick="openModal('contrat', ${contrat.id_contrat})">Modifier</button>
                            <button class="btn btn-danger" onclick="deleteEntity('contrat', ${contrat.id_contrat})">Supprimer</button>
                        </td>
                    </tr>
                `;
            });
        }
    } catch (error) {
        console.error('Error loading contrat table:', error);
    }
}

// Load Dashboard
async function loadDashboard() {
    try {
        const [personnel, poste, annonce, candidature] = await Promise.all([
            Personnel.getAll(),
            Poste.getAll(),
            Annonce.getActive(),
            Candidature.getAll()
        ]);

        document.getElementById('count-personnel').textContent = personnel.data?.length || 0;
        document.getElementById('count-poste').textContent = poste.data?.length || 0;
        document.getElementById('count-annonce').textContent = annonce.data?.length || 0;
        document.getElementById('count-candidature').textContent = candidature.data?.length || 0;
    } catch (error) {
        console.error('Error loading dashboard:', error);
    }
}

// Delete entity
async function deleteEntity(entity, id) {
    if (!confirm('Êtes-vous sûr de vouloir supprimer cet enregistrement?')) {
        return;
    }

    try {
        let response;
        
        switch(entity) {
            case 'personnel':
                response = await Personnel.delete(id);
                break;
            case 'poste':
                response = await Poste.delete(id);
                break;
            case 'annonce':
                response = await Annonce.delete(id);
                break;
            case 'candidature':
                response = await Candidature.delete(id);
                break;
            case 'contrat':
                response = await Contrat.delete(id);
                break;
        }

        if (response.success) {
            showToast('Enregistrement supprimé avec succès');
            loadSectionData(entity);
        } else {
            showToast('Erreur lors de la suppression', 'error');
        }
    } catch (error) {
        console.error('Error deleting entity:', error);
        showToast('Erreur lors de la suppression', 'error');
    }
}
