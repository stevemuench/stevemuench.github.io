async function listFiles() {
    const repo = 'stevemuench/stevemuench.github.io'; // Replace with your GitHub username and repository name
    const branch = 'main'; // Replace with your default branch if different
    const apiURL = `https://api.github.com/repos/${repo}/git/trees/${branch}?recursive=1`;
    
    try {
        const response = await fetch(apiURL);
        if (!response.ok) {
            throw new Error('Network response was not ok ' + response.statusText);
        }
        const data = await response.json();
        
        const fileList = document.getElementById('fileList');
        
        data.tree.forEach(file => {
            if (file.type === 'blob') {
                const listItem = document.createElement('li');
                const link = document.createElement('a');
                link.href = file.path;
                link.textContent = file.path;
                listItem.appendChild(link);
                fileList.appendChild(listItem);
            }
        });
    } catch (error) {
        console.error('There has been a problem with your fetch operation:', error);
    }
}

document.addEventListener('DOMContentLoaded', listFiles);
