<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, viewport-fit=cover">
<title>FPS Monitor Pro</title>
<style>
*{box-sizing:border-box;-webkit-tap-highlight-color:transparent}
body{margin:0;min-height:100vh;background:radial-gradient(circle at top,#202020 0%,#080808 45%,#000 100%);color:white;font-family:-apple-system,BlinkMacSystemFont,"SF Pro Display",Arial,sans-serif;display:flex;justify-content:center;align-items:center}
.container{width:90%;max-width:390px}
.header{text-align:center;margin-bottom:20px;display:flex;justify-content:space-between;align-items:center}
.header h1{margin:0;font-size:30px;font-weight:800;letter-spacing:3px}
.header p{margin:7px 0 0;color:#777;font-size:13px}
.theme-toggle{background:#1a1a1a;border:1px solid #292929;border-radius:50%;width:45px;height:45px;cursor:pointer;display:flex;align-items:center;justify-content:center;transition:all .3s ease;font-size:20px}
.theme-toggle:hover{background:#242424;border-color:#3a3a3a}
.fps-card{position:relative;overflow:hidden;background:linear-gradient(145deg,#191919,#0c0c0c);border:1px solid #292929;border-radius:28px;padding:30px 25px;box-shadow:0 20px 50px rgba(0,0,0,.6),inset 0 1px rgba(255,255,255,.05);text-align:center;transition:all .3s ease}
.fps-card.high{border-color:#00e6a0;box-shadow:0 20px 50px rgba(0,230,160,.2),inset 0 1px rgba(0,230,160,.1)}
.fps-card.medium{border-color:#ffaa00;box-shadow:0 20px 50px rgba(255,170,0,.2),inset 0 1px rgba(255,170,0,.1)}
.fps-card.low{border-color:#ff4444;box-shadow:0 20px 50px rgba(255,68,68,.2),inset 0 1px rgba(255,68,68,.1)}
.fps-card::before{content:"";position:absolute;width:180px;height:180px;background:rgba(0,255,170,.08);filter:blur(60px);top:-80px;left:50%;transform:translateX(-50%);transition:all .3s ease}
.fps-card.medium::before{background:rgba(255,170,0,.08)}
.fps-card.low::before{background:rgba(255,68,68,.08)}
.fps-label{position:relative;color:#888;font-size:14px;letter-spacing:2px}
#fps{position:relative;margin:3px 0;font-size:76px;line-height:1;font-weight:900;font-variant-numeric:tabular-nums;transition:color .2s ease}
.fps-card.high #fps{color:#00e6a0}
.fps-card.medium #fps{color:#ffaa00}
.fps-card.low #fps{color:#ff4444}
.unit{position:relative;color:#888;font-size:15px}
.status{position:relative;display:inline-flex;align-items:center;gap:7px;margin-top:17px;padding:7px 13px;border-radius:30px;background:#151515;border:1px solid #292929;font-size:12px;color:#aaa;transition:all .3s ease}
.status.recording{border-color:#ff4444;background:#ff444420}
.dot{width:7px;height:7px;border-radius:50%;background:#00e6a0;box-shadow:0 0 10px #00e6a0;animation:pulse 2s infinite}
.dot.inactive{animation:none;background:#666;box-shadow:none}
@keyframes pulse{0%,100%{opacity:1}50%{opacity:.5}}
.stats{display:grid;grid-template-columns:1fr 1fr;gap:12px;margin-top:14px}
.stat{background:#111;border:1px solid #242424;border-radius:18px;padding:17px;text-align:left;transition:all .3s ease}
.stat:hover{border-color:#3a3a3a;background:#151515}
.stat-title{color:#777;font-size:12px;letter-spacing:1px;text-transform:uppercase}
.stat-value{margin-top:5px;font-size:25px;font-weight:750;font-variant-numeric:tabular-nums}
canvas{width:100%;height:90px;margin-top:14px;background:#111;border:1px solid #242424;border-radius:18px}
button{width:100%;margin-top:15px;padding:15px;border:0;border-radius:17px;background:#fff;color:#000;font-size:15px;font-weight:750;cursor:pointer;transition:all .2s ease}
button:hover{background:#e0e0e0}
button:active{transform:scale(.97)}
button.recording{background:#ff4444;color:#fff}
button.recording:hover{background:#ff6666}
.footer{text-align:center;margin-top:15px;color:#555;font-size:11px;line-height:1.5}
.info-badge{display:inline-block;margin-top:10px;padding:8px 12px;background:#1a1a1a;border:1px solid #292929;border-radius:15px;font-size:11px;color:#777;letter-spacing:.5px}
</style>
</head>
<body>
<div class="container">
    <div class="header">
        <div>
            <h1>FPS MONITOR</h1>
            <p>Pro com gráfico</p>
        </div>
        <button class="theme-toggle" id="themeToggle" title="Alternar tema">🌙</button>
    </div>
    <div class="fps-card" id="fpsCard">
        <div class="fps-label">FPS ATUAL</div>
        <div id="fps">--</div>
        <div class="unit">FRAMES POR SEGUNDO</div>
        <div class="status"><span class="dot"></span><span id="statusText">MONITORANDO</span></div>
    </div>
    <canvas id="chart" width="780" height="180"></canvas>
    <div class="stats">
        <div class="stat"><div class="stat-title">MÉDIA</div><div class="stat-value" id="avg">--</div></div>
        <div class="stat"><div class="stat-title">MÁXIMO</div><div class="stat-value" id="max">--</div></div>
        <div class="stat"><div class="stat-title">MÍNIMO</div><div class="stat-value" id="min">--</div></div>
        <div class="stat"><div class="stat-title">FRAME TIME</div><div class="stat-value" id="frameTime">--</div></div>
    </div>
    <button id="recordBtn" onclick="toggleRecording()">📹 GRAVAR DADOS</button>
    <div class="info-badge" id="recordInfo" style="display:none;">Dados sendo registrados...</div>
    <div class="footer">
        <p>© 2026 FPS Monitor Pro | Monitoramento em tempo real</p>
        <p id="fps-precision">Precisão: 60 amostras</p>
    </div>
</div>

<script>
const fpsEl = document.getElementById('fps');
const avgEl = document.getElementById('avg');
const maxEl = document.getElementById('max');
const minEl = document.getElementById('min');
const frameTimeEl = document.getElementById('frameTime');
const canvas = document.getElementById('chart');
const ctx = canvas.getContext('2d', { willReadFrequently: true });
const fpsCard = document.getElementById('fpsCard');
const themeToggle = document.getElementById('themeToggle');
const recordBtn = document.getElementById('recordBtn');
const recordInfo = document.getElementById('recordInfo');
const statusText = document.getElementById('statusText');

let fps = 0;
let fpsHistory = [];
let isRecording = false;
let recordedData = [];
const maxHistory = 60;
const updateInterval = 1000;
let lastTime = performance.now();
let frameCount = 0;
let isDarkMode = true;

// Theme Toggle
themeToggle.addEventListener('click', () => {
    isDarkMode = !isDarkMode;
    document.body.style.background = isDarkMode 
        ? 'radial-gradient(circle at top,#202020 0%,#080808 45%,#000 100%)' 
        : 'radial-gradient(circle at top,#f5f5f5 0%,#e8e8e8 45%,#ddd 100%)';
    document.body.style.color = isDarkMode ? 'white' : '#000';
    themeToggle.textContent = isDarkMode ? '🌙' : '☀️';
});

// FPS Calculation
function calculateFPS() {
    const now = performance.now();
    const delta = now - lastTime;
    
    if (delta >= updateInterval) {
        fps = Math.round((frameCount * 1000) / delta);
        fpsHistory.push(fps);
        
        if (fpsHistory.length > maxHistory) {
            fpsHistory.shift();
        }
        
        if (isRecording) {
            recordedData.push({ timestamp: new Date().toISOString(), fps: fps });
        }
        
        updateDisplay();
        drawChart();
        
        frameCount = 0;
        lastTime = now;
    }
    
    frameCount++;
    requestAnimationFrame(calculateFPS);
}

function updateDisplay() {
    fpsEl.textContent = fps;
    
    // Update card color based on FPS
    fpsCard.classList.remove('high', 'medium', 'low');
    if (fps >= 60) fpsCard.classList.add('high');
    else if (fps >= 30) fpsCard.classList.add('medium');
    else fpsCard.classList.add('low');
    
    if (fpsHistory.length === 0) return;
    
    const avg = Math.round(fpsHistory.reduce((a, b) => a + b) / fpsHistory.length);
    const max = Math.max(...fpsHistory);
    const min = Math.min(...fpsHistory);
    const frameTime = fps > 0 ? (1000 / fps).toFixed(2) : '--';
    
    avgEl.textContent = avg;
    maxEl.textContent = max;
    minEl.textContent = min;
    frameTimeEl.textContent = frameTime !== '--' ? `${frameTime}ms` : '--';
}

function drawChart() {
    const width = canvas.width;
    const height = canvas.height;
    const padding = 10;
    const graphWidth = width - 2 * padding;
    const graphHeight = height - 2 * padding;
    
    // Clear canvas
    ctx.fillStyle = isDarkMode ? '#111' : '#f9f9f9';
    ctx.fillRect(0, 0, width, height);
    
    // Grid
    ctx.strokeStyle = isDarkMode ? '#242424' : '#e0e0e0';
    ctx.lineWidth = 1;
    for (let i = 0; i <= 4; i++) {
        const y = padding + (graphHeight / 4) * i;
        ctx.beginPath();
        ctx.moveTo(padding, y);
        ctx.lineTo(width - padding, y);
        ctx.stroke();
    }
    
    // Draw FPS line
    if (fpsHistory.length > 1) {
        ctx.strokeStyle = '#00e6a0';
        ctx.lineWidth = 2;
        ctx.beginPath();
        
        fpsHistory.forEach((val, idx) => {
            const x = padding + (graphWidth / (maxHistory - 1)) * idx;
            const y = height - padding - (val / 120) * graphHeight;
            
            if (idx === 0) ctx.moveTo(x, y);
            else ctx.lineTo(x, y);
        });
        
        ctx.stroke();
        
        // Fill area
        ctx.fillStyle = 'rgba(0, 230, 160, 0.1)';
        ctx.lineTo(width - padding, height - padding);
        ctx.lineTo(padding, height - padding);
        ctx.fill();
    }
    
    // Labels
    ctx.fillStyle = isDarkMode ? '#777' : '#888';
    ctx.font = '11px Arial';
    ctx.textAlign = 'right';
    ctx.fillText('120', width - 5, padding + 10);
    ctx.fillText('60', width - 5, padding + graphHeight / 2);
    ctx.fillText('0', width - 5, height - padding + 10);
}

function toggleRecording() {
    isRecording = !isRecording;
    recordBtn.classList.toggle('recording', isRecording);
    recordInfo.style.display = isRecording ? 'block' : 'none';
    recordBtn.textContent = isRecording ? '⏹️ PARAR GRAVAÇÃO' : '📹 GRAVAR DADOS';
    
    if (!isRecording && recordedData.length > 0) {
        downloadRecording();
    }
}

function downloadRecording() {
    const csv = 'timestamp,fps\n' + recordedData.map(d => `${d.timestamp},${d.fps}`).join('\n');
    const blob = new Blob([csv], { type: 'text/csv' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = `fps-monitor-${new Date().getTime()}.csv`;
    a.click();
    URL.revokeObjectURL(url);
    recordedData = [];
}

// Start monitoring
calculateFPS();
</script>
</body>
</html>