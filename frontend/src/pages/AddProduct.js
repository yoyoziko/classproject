import React, { useState } from 'react';
import axios from 'axios';
import { Container, Form, Button } from 'react-bootstrap';

const AddProduct = () => {
  const [product, setProduct] = useState({
    name: '',
    image: '',
    price: '',
    description: '',
  });

  const handleChange = (e) => {
    setProduct({ ...product, [e.target.name]: e.target.value });
  };

  const handleImageChange = (e) => {
    setProduct({ ...product, image: e.target.files[0] });
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    const formData = new FormData();
    for (let key in product) {
      formData.append(key, product[key]);
    }

    const token = localStorage.getItem('token');
    axios.post('/api/products', formData, {
      headers: {
        'Authorization': token,
        'Content-Type': 'multipart/form-data'
      }
    })
    .then(response => {
      if (response.data.success) {
        alert('Product added successfully');
        setProduct({ name: '', image: '', price: '', description: '' });
      } else {
        alert('Failed to add product');
      }
    })
    .catch(error => console.error(error));
  };

  return (
    <Container className="my-4">
      <h1>Add Product</h1>
      <Form onSubmit={handleSubmit}>
        <Form.Group controlId="formName" className="mb-3">
          <Form.Label>Name</Form.Label>
          <Form.Control type="text" name="name" value={product.name} onChange={handleChange} placeholder="Enter product name" required />
        </Form.Group>
        <Form.Group controlId="formImage" className="mb-3">
          <Form.Label>Image</Form.Label>
          <Form.Control type="file" name="image" onChange={handleImageChange} placeholder="Upload product image" required />
        </Form.Group>
        <Form.Group controlId="formPrice" className="mb-3">
          <Form.Label>Price</Form.Label>
          <Form.Control type="number" name="price" value={product.price} onChange={handleChange} placeholder="Enter product price" required />
        </Form.Group>
        <Form.Group controlId="formDescription" className="mb-3">
          <Form.Label>Description</Form.Label>
          <Form.Control as="textarea" name="description" value={product.description} onChange={handleChange} placeholder="Enter product description" required />
        </Form.Group>
        <Button variant="primary" type="submit" className="mt-3">
          Add Product
        </Button>
      </Form>
    </Container>
  );
};

export default AddProduct;
