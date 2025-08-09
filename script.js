// DOM Elements
const searchInput = document.getElementById('searchInput');
const searchBtn = document.getElementById('searchBtn');
const randomBtn = document.getElementById('randomBtn');
const allWordsBtn = document.getElementById('allWordsBtn');
const welcomeMessage = document.getElementById('welcomeMessage');
const resultsContainer = document.getElementById('resultsContainer');
const resultsTitle = document.getElementById('resultsTitle');
const resultsCount = document.getElementById('resultsCount');
const wordsGrid = document.getElementById('wordsGrid');
const loading = document.getElementById('loading');

// API Base URL
const API_BASE = 'http://localhost:8080';

// Event Listeners
searchBtn.addEventListener('click', handleSearch);
randomBtn.addEventListener('click', handleRandomWord);
allWordsBtn.addEventListener('click', handleAllWords);
searchInput.addEventListener('keypress', (e) => {
    if (e.key === 'Enter') {
        handleSearch();
    }
});

// Search functionality
async function handleSearch() {
    const query = searchInput.value.trim();
    if (!query) {
        showNotification('Vui lòng nhập từ cần tìm kiếm!', 'warning');
        return;
    }
    
    showLoading(true);
    try {
        const response = await fetch(`${API_BASE}/api/search/${encodeURIComponent(query)}`);
        const data = await response.json();
        
        if (data.length === 0) {
            showNoResults(query);
        } else {
            displayResults(data, `Kết quả tìm kiếm cho "${query}"`);
        }
    } catch (error) {
        console.error('Lỗi tìm kiếm:', error);
        showNotification('Có lỗi xảy ra khi tìm kiếm. Vui lòng thử lại!', 'error');
    } finally {
        showLoading(false);
    }
}

// Random word functionality
async function handleRandomWord() {
    showLoading(true);
    try {
        const response = await fetch(`${API_BASE}/api/random`);
        const data = await response.json();
        
        if (data.word) {
            displayResults([data], 'Từ ngẫu nhiên');
        } else {
            showNotification('Không thể lấy từ ngẫu nhiên. Vui lòng thử lại!', 'error');
        }
    } catch (error) {
        console.error('Lỗi lấy từ ngẫu nhiên:', error);
        showNotification('Có lỗi xảy ra. Vui lòng thử lại!', 'error');
    } finally {
        showLoading(false);
    }
}

// All words functionality
async function handleAllWords() {
    showLoading(true);
    try {
        const response = await fetch(`${API_BASE}/api/words`);
        const data = await response.json();
        
        if (data.length > 0) {
            displayResults(data, 'Tất cả từ vựng');
        } else {
            showNotification('Không có từ vựng nào trong cơ sở dữ liệu!', 'warning');
        }
    } catch (error) {
        console.error('Lỗi lấy tất cả từ:', error);
        showNotification('Có lỗi xảy ra khi lấy dữ liệu. Vui lòng thử lại!', 'error');
    } finally {
        showLoading(false);
    }
}

// Display search results
function displayResults(words, title) {
    resultsTitle.textContent = title;
    resultsCount.textContent = `${words.length} từ`;
    
    wordsGrid.innerHTML = '';
    
    words.forEach(word => {
        const wordCard = createWordCard(word);
        wordsGrid.appendChild(wordCard);
    });
    
    welcomeMessage.style.display = 'none';
    resultsContainer.style.display = 'block';
    
    // Smooth scroll to results
    resultsContainer.scrollIntoView({ behavior: 'smooth' });
}

// Create word card
function createWordCard(word) {
    const card = document.createElement('div');
    card.className = 'word-card';
    
    card.innerHTML = `
        <div class="word-header">
            <div class="word-info">
                <h4>${word.word}</h4>
                <div class="pronunciation">${word.pronunciation}</div>
            </div>
        </div>
        <div class="meaning">${word.meaning}</div>
        <div class="examples">
            <h5><i class="fas fa-language"></i> Ví dụ:</h5>
            <div class="example-text">
                <strong>Tiếng Anh:</strong> ${word.example_en}
            </div>
            <div class="example-text">
                <strong>Tiếng Việt:</strong> ${word.example_vi}
            </div>
        </div>
    `;
    
    // Add click effect
    card.addEventListener('click', () => {
        card.style.transform = 'scale(0.98)';
        setTimeout(() => {
            card.style.transform = '';
        }, 150);
    });
    
    return card;
}

// Show no results message
function showNoResults(query) {
    wordsGrid.innerHTML = `
        <div class="no-results" style="grid-column: 1 / -1; text-align: center; padding: 50px;">
            <i class="fas fa-search" style="font-size: 3rem; color: #ccc; margin-bottom: 20px;"></i>
            <h3>Không tìm thấy từ "${query}"</h3>
            <p>Hãy thử tìm kiếm với từ khác hoặc sử dụng tính năng "Từ ngẫu nhiên" để học từ mới!</p>
        </div>
    `;
    
    resultsTitle.textContent = `Kết quả tìm kiếm cho "${query}"`;
    resultsCount.textContent = '0 từ';
    
    welcomeMessage.style.display = 'none';
    resultsContainer.style.display = 'block';
}

// Show/hide loading
function showLoading(show) {
    if (show) {
        loading.style.display = 'block';
        welcomeMessage.style.display = 'none';
        resultsContainer.style.display = 'none';
    } else {
        loading.style.display = 'none';
    }
}

// Show notification
function showNotification(message, type = 'info') {
    // Remove existing notification
    const existingNotification = document.querySelector('.notification');
    if (existingNotification) {
        existingNotification.remove();
    }
    
    const notification = document.createElement('div');
    notification.className = `notification notification-${type}`;
    notification.innerHTML = `
        <div class="notification-content">
            <i class="fas ${getNotificationIcon(type)}"></i>
            <span>${message}</span>
            <button class="notification-close">&times;</button>
        </div>
    `;
    
    // Add styles
    notification.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        background: ${getNotificationColor(type)};
        color: white;
        padding: 15px 20px;
        border-radius: 10px;
        box-shadow: 0 10px 30px rgba(0,0,0,0.2);
        z-index: 1000;
        max-width: 400px;
        animation: slideInRight 0.3s ease-out;
    `;
    
    // Add animation styles
    const style = document.createElement('style');
    style.textContent = `
        @keyframes slideInRight {
            from {
                transform: translateX(100%);
                opacity: 0;
            }
            to {
                transform: translateX(0);
                opacity: 1;
            }
        }
        
        .notification-content {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .notification-close {
            background: none;
            border: none;
            color: white;
            font-size: 1.2rem;
            cursor: pointer;
            margin-left: auto;
        }
    `;
    document.head.appendChild(style);
    
    // Close button functionality
    const closeBtn = notification.querySelector('.notification-close');
    closeBtn.addEventListener('click', () => {
        notification.remove();
    });
    
    document.body.appendChild(notification);
    
    // Auto remove after 5 seconds
    setTimeout(() => {
        if (notification.parentNode) {
            notification.remove();
        }
    }, 5000);
}

// Get notification icon
function getNotificationIcon(type) {
    switch (type) {
        case 'success': return 'fa-check-circle';
        case 'error': return 'fa-exclamation-circle';
        case 'warning': return 'fa-exclamation-triangle';
        default: return 'fa-info-circle';
    }
}

// Get notification color
function getNotificationColor(type) {
    switch (type) {
        case 'success': return '#28a745';
        case 'error': return '#dc3545';
        case 'warning': return '#ffc107';
        default: return '#17a2b8';
    }
}

// Initialize app
function initApp() {
    // Add some interactive features
    searchInput.focus();
    
    // Add typing effect to subtitle
    const subtitle = document.querySelector('.subtitle');
    const originalText = subtitle.textContent;
    subtitle.textContent = '';
    
    let i = 0;
    const typeWriter = () => {
        if (i < originalText.length) {
            subtitle.textContent += originalText.charAt(i);
            i++;
            setTimeout(typeWriter, 50);
        }
    };
    
    // Start typing effect after a short delay
    setTimeout(typeWriter, 1000);
    
    // Add floating animation to logo icon
    const logoIcon = document.querySelector('.logo i');
    logoIcon.style.animation = 'float 3s ease-in-out infinite';
    
    // Add floating animation styles
    const floatStyle = document.createElement('style');
    floatStyle.textContent = `
        @keyframes float {
            0%, 100% { transform: translateY(0px); }
            50% { transform: translateY(-10px); }
        }
    `;
    document.head.appendChild(floatStyle);
}

// Start the app when DOM is loaded
document.addEventListener('DOMContentLoaded', initApp);

// Add some fun interactions
document.addEventListener('click', (e) => {
    // Add ripple effect to buttons
    if (e.target.tagName === 'BUTTON') {
        const ripple = document.createElement('span');
        const rect = e.target.getBoundingClientRect();
        const size = Math.max(rect.width, rect.height);
        const x = e.clientX - rect.left - size / 2;
        const y = e.clientY - rect.top - size / 2;
        
        ripple.style.cssText = `
            position: absolute;
            width: ${size}px;
            height: ${size}px;
            left: ${x}px;
            top: ${y}px;
            background: rgba(255,255,255,0.3);
            border-radius: 50%;
            transform: scale(0);
            animation: ripple 0.6s linear;
            pointer-events: none;
        `;
        
        e.target.style.position = 'relative';
        e.target.appendChild(ripple);
        
        setTimeout(() => {
            ripple.remove();
        }, 600);
    }
});

// Add ripple animation
const rippleStyle = document.createElement('style');
rippleStyle.textContent = `
    @keyframes ripple {
        to {
            transform: scale(4);
            opacity: 0;
        }
    }
`;
document.head.appendChild(rippleStyle);
