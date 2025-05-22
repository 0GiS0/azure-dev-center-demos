import React, { useEffect, useState } from 'react';

const ProjectsList = () => {
    const [projects, setProjects] = useState([]);

    useEffect(() => {
        fetch('/projects')
            .then(response => response.json())
            .then(data => setProjects(data));
    }, []);

    return (
        <div>
            <h1>Projects</h1>
            <ul>
                {projects.map(project => (
                    <li key={project.id}>{project.name}</li>
                ))}
            </ul>
        </div>
    );
};

export default ProjectsList;