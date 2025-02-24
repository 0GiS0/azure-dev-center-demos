import React, { useEffect, useState } from 'react';
import { getDevBoxes } from '../services/devBoxesService';
import styles from './DevBoxesList.module.css';

function DevBoxesList() {
  const [devBoxes, setDevBoxes] = useState([]);

  useEffect(() => {
    const fetchDevBoxes = async () => {
      try {

        console.log('Fetching dev boxes...');

        const data = await getDevBoxes();
        setDevBoxes(data);
      } catch (error) {
        console.error('Error fetching dev boxes:', error);
      }
    };

    fetchDevBoxes();
  }, []);

  const getStatusClass = (state) => {
    switch (state?.toLowerCase()) {
      case 'running':
        return 'running';
      case 'stopped':
        return 'stopped';
      case 'hibernated':
        return 'hibernated';
      default:
        return 'stopped';
    }
  };

  return (
    <div className={styles.container}>
      <h2 className={styles.title}>Your dev boxes</h2>
      <ul className={styles.boxesList}>
        {devBoxes.map((box) => (
          <li key={box.id} className={styles.boxItem}>
            <div className={styles.boxImageContainer}>
              {/* Temporalmente removemos la imagen hasta tener el logo correcto */}
            </div>
            <div className={styles.boxContent}>
              <h3 className={styles.boxName}>{box.name}</h3>
              <p className={styles.status}>
                <span className={`${styles.statusIndicator} ${styles[getStatusClass(box.provisioningState)]}`}></span>
                {box.provisioningState || 'Unknown'}
              </p>
            </div>
          </li>
        ))}
      </ul>
    </div>
  );
}

export default DevBoxesList;