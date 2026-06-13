const app = document.getElementById('app');

async function fetchHealth() {
  try {
    const res = await fetch('http://localhost:8000/health');
    const data = await res.json();
    app.innerHTML = `<pre>${JSON.stringify(data, null, 2)}</pre>`;
  } catch (err) {
    app.innerHTML = `<p>Backend not reachable: ${err.message}</p>`;
  }
}

fetchHealth();
