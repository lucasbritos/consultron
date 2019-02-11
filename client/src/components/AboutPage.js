import React from 'react';
import { Link } from 'react-router-dom';
import '../styles/about-page.css';

// Since this component is simple and static, there's no parent container for it.
const AboutPage = () => {
  return (
    <div>
      <h2 className="alt-header">About</h2>
      <p> Author: Lucas Britos </p>
      <p> This project use: </p>
        <ul>
          <li>Node.js</li>
          <li>Postgres</li>
          <li>React.js / Redux</li>
          <li><a href="https://github.com/coryhouse/react-slingshot">React-Slingshot starter kit</a></li>
        </ul>

      <p>
        <Link to="/badlink">Click this bad link</Link> to see the 404 page.
      </p>
    </div>
  );
};

export default AboutPage;
