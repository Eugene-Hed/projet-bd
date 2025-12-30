// ==================== MAIN APP LOGIC ====================

// Initialize app
document.addEventListener('DOMContentLoaded', () => {
    initializeApp();
});

function initializeApp() {
    // Set up navigation
    setupNavigation();
    
    // Load dashboard on startup
    navigateTo('dashboard');
    
    // Update current time
    updateClock();
    setInterval(updateClock, 1000);
}

// Navigation setup
function setupNavigation() {
    document.querySelectorAll('.nav-link').forEach(link => {
        link.addEventListener('click', (e) => {
            e.preventDefault();
            const section = link.dataset.section;
            navigateTo(section);
        });
    });
}

// Update clock
function updateClock() {
    const now = new Date();
    const timeString = now.toLocaleTimeString('fr-FR', {
        hour: '2-digit',
        minute: '2-digit',
        second: '2-digit'
    });
    document.getElementById('current-time').textContent = timeString;
}

// Handle form submission
async function handleFormSubmit(event) {
    event.preventDefault();
    
    const form = document.getElementById('entity-form');
    const entity = form.dataset.entity;
    const id = form.dataset.id;
    
    // Collect form data
    const formData = new FormData(form);
    const data = Object.fromEntries(formData);
    
    // Convert number fields
    ['id_personnel', 'id_poste', 'id_annonce', 'id_candidature', 'id_contrat', 
     'nombrePostesDisponibles', 'dureeContratPrevu', 'note', 'salaire'].forEach(field => {
        if (data[field]) {
            data[field] = parseInt(data[field]);
        }
    });
    
    try {
        let response;
        
        if (id) {
            // Update existing
            switch(entity) {
                case 'personnel':
                    response = await Personnel.update(id, data);
                    break;
                case 'poste':
                    response = await Poste.update(id, data);
                    break;
                case 'annonce':
                    response = await Annonce.update(id, data);
                    break;
                case 'candidature':
                    response = await Candidature.update(id, data);
                    break;
                case 'contrat':
                    response = await Contrat.update(id, data);
                    break;
            }
            
            if (response.success) {
                showToast('Enregistrement modifié avec succès');
            } else {
                showToast('Erreur lors de la modification', 'error');
            }
        } else {
            // Create new
            switch(entity) {
                case 'personnel':
                    response = await Personnel.create(data);
                    break;
                case 'poste':
                    response = await Poste.create(data);
                    break;
                case 'annonce':
                    response = await Annonce.create(data);
                    break;
                case 'candidature':
                    response = await Candidature.create(data);
                    break;
                case 'contrat':
                    response = await Contrat.create(data);
                    break;
            }
            
            if (response.success) {
                showToast('Enregistrement créé avec succès');
            } else {
                showToast('Erreur lors de la création', 'error');
            }
        }
        
        // Refresh table and close modal
        closeModal();
        loadSectionData(entity);
        
    } catch (error) {
        console.error('Error submitting form:', error);
        showToast('Erreur lors de l\'enregistrement', 'error');
    }
}

// Add badge styles dynamically
const style = document.createElement('style');
style.innerHTML = `
    .badge {
        padding: 4px 8px;
        border-radius: 4px;
        font-size: 12px;
        font-weight: 600;
    }
    
    .badge.active {
        background-color: #d4edda;
        color: #155724;
    }
    
    .badge.inactive {
        background-color: #f8d7da;
        color: #721c24;
    }
`;
document.head.appendChild(style);
