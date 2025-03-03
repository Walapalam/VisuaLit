import styled from "styled-components";

export const MiddleBlockSection = styled.section`
  position: relative;
  padding: 7.5rem 0 3rem;
  text-align: center;
  display: flex;
  justify-content: center;
  border: 2px solid rgb(143, 229, 192);  // Changed to green border
  border-radius: 10px;
  margin: 2rem;
  background: white;  // Changed to white background
  box-shadow: 0 4px 8px rgba(143, 229, 192, 0.2);  // Changed to green shadow

  @media screen and (max-width: 1024px) {
    padding: 5.5rem 0 3rem;
  }
`;

export const Content = styled.p`
  padding: 0.75rem 0 0.75rem;
`;

export const ContentWrapper = styled.div`
  max-width: 570px;
  padding: 0 2rem;
  
  @media only screen and (max-width: 768px) {
    max-width: 100%;
  }
`;
