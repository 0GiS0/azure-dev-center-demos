import axios from 'axios';

const API_URL = 'http://localhost:3000/devboxes';

export const getDevBoxes = async () => {
  try {
    console.log('Fetching dev boxes from API...');

    const response = await axios.get(API_URL);

    console.log('Dev boxes fetched successfully:', response.data);

    return response.data;
  } catch (error) {
    console.error('Error fetching dev boxes:', error);
    throw error;
  }
};
