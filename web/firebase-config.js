// Firebase Web SDK Konfiguration
import { initializeApp } from 'firebase/app';
import { getAuth } from 'firebase/auth';
import { getFirestore } from 'firebase/firestore';

const firebaseConfig = {
    apiKey: "AIzaSyCYZ7dSyDBJ60ZS9pNlofJzh_No5VfPmmM",
    authDomain: "unbarmherzigkeit-auth.firebaseapp.com",
    projectId: "unbarmherzigkeit-auth",
    storageBucket: "unbarmherzigkeit-auth.firebasestorage.app",
    messagingSenderId: "330428788627",
    appId: "1:330428788627:web:93a715d892b8909bf24266",
    measurementId: "G-4SSR7VTCV6"
};

// Firebase initialisieren
const app = initializeApp(firebaseConfig);
export const auth = getAuth(app);
export const db = getFirestore(app);