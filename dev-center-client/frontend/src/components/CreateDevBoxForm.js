import React, { useState } from 'react';
import styles from './CreateDevBoxForm.module.css';

const CreateDevBoxForm = () => {
    const [isVisible, setIsVisible] = useState(false);
    const [projectName, setProjectName] = useState('');
    const [userId, setUserId] = useState('');

    const handleSubmit = (event) => {
        event.preventDefault();
        fetch(`/devboxes/${projectName}/${userId}`, {
            method: 'POST',
        })
            .then(response => response.json())
            .then(data => {
                console.log('DevBox created:', data);
                setIsVisible(false); // Cerrar el panel después de crear
            });
    };

    return (
        <>
            <button 
                className={styles.createButton} 
                onClick={() => setIsVisible(true)}
                aria-label="Create new DevBox"
            >
                +
            </button>

            <div className={`${styles.sidePanel} ${isVisible ? styles.visible : ''}`}>
                <button 
                    className={styles.closeButton}
                    onClick={() => setIsVisible(false)}
                    aria-label="Close panel"
                >
                    ×
                </button>
                <form onSubmit={handleSubmit} className={styles.form}>
                    <h2>Create New DevBox</h2>
                    <div className={styles.formGroup}>
                        <label htmlFor="projectName">Project Name:</label>
                        <input
                            id="projectName"
                            type="text"
                            value={projectName}
                            onChange={(e) => setProjectName(e.target.value)}
                            required
                        />
                    </div>
                    <div className={styles.formGroup}>
                        <label htmlFor="userId">User ID:</label>
                        <input
                            id="userId"
                            type="text"
                            value={userId}
                            onChange={(e) => setUserId(e.target.value)}
                            required
                        />
                    </div>
                    <button type="submit" className={styles.submitButton}>
                        Create DevBox
                    </button>
                </form>
            </div>
        </>
    );
};

export default CreateDevBoxForm;