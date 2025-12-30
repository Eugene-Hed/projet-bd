// ==================== API CLIENT ====================

const API_BASE_URL = '/api';

// Generic API request function
async function apiRequest(endpoint, method = 'GET', data = null) {
    try {
        const options = {
            method: method,
            headers: {
                'Content-Type': 'application/json',
            }
        };

        if (data) {
            options.body = JSON.stringify(data);
        }

        const response = await fetch(`${API_BASE_URL}${endpoint}`, options);
        
        if (!response.ok) {
            throw new Error(`HTTP ${response.status}`);
        }

        return await response.json();
    } catch (error) {
        console.error('API Error:', error);
        throw error;
    }
}

// ==================== PERSONNEL API ====================
const Personnel = {
    getAll: () => apiRequest('/personnel'),
    getById: (id) => apiRequest(`/personnel/${id}`),
    create: (data) => apiRequest('/personnel', 'POST', data),
    update: (id, data) => apiRequest(`/personnel/${id}`, 'PUT', data),
    delete: (id) => apiRequest(`/personnel/${id}`, 'DELETE')
};

// ==================== POSTE API ====================
const Poste = {
    getAll: () => apiRequest('/poste'),
    getById: (id) => apiRequest(`/poste/${id}`),
    create: (data) => apiRequest('/poste', 'POST', data),
    update: (id, data) => apiRequest(`/poste/${id}`, 'PUT', data),
    delete: (id) => apiRequest(`/poste/${id}`, 'DELETE')
};

// ==================== ANNONCE API ====================
const Annonce = {
    getAll: () => apiRequest('/annonce'),
    getActive: () => apiRequest('/annonce/active'),
    getById: (id) => apiRequest(`/annonce/${id}`),
    create: (data) => apiRequest('/annonce', 'POST', data),
    update: (id, data) => apiRequest(`/annonce/${id}`, 'PUT', data),
    delete: (id) => apiRequest(`/annonce/${id}`, 'DELETE')
};

// ==================== CANDIDATURE API ====================
const Candidature = {
    getAll: () => apiRequest('/candidature'),
    getById: (id) => apiRequest(`/candidature/${id}`),
    getByAnnonce: (id) => apiRequest(`/candidature/annonce/${id}`),
    create: (data) => apiRequest('/candidature', 'POST', data),
    update: (id, data) => apiRequest(`/candidature/${id}`, 'PUT', data),
    delete: (id) => apiRequest(`/candidature/${id}`, 'DELETE')
};

// ==================== CONTRAT API ====================
const Contrat = {
    getAll: () => apiRequest('/contrat'),
    getById: (id) => apiRequest(`/contrat/${id}`),
    create: (data) => apiRequest('/contrat', 'POST', data),
    update: (id, data) => apiRequest(`/contrat/${id}`, 'PUT', data),
    delete: (id) => apiRequest(`/contrat/${id}`, 'DELETE')
};
