import React from 'react';
import './App.css';
import DevBoxesList from './components/DevBoxesList';
import CreateDevBoxForm from './components/CreateDevBoxForm';

function App() {
  return (
    <div className="App">
      <header className="App-header">
        <div className="header-left">
          <h1>Dev Center Client</h1>
          <select className="project-select">
            <option>Default Project</option>
          </select>
        </div>
      </header>
      <main>
        <div className="content">
          <DevBoxesList />
          <CreateDevBoxForm />
        </div>
      </main>
    </div>
  );
}

export default App;
