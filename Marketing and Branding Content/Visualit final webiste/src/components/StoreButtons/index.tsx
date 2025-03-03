import styled from "styled-components";

const ButtonContainer = styled.div`
  display: flex;
  gap: 20px;
  margin-top: 24px;
  flex-direction: column;  // Changed to column layout
  align-items: flex-start; // Align buttons to the left
`;

const StoreButton = styled.a`
  display: inline-block;
  transition: all 0.3s ease-in-out;
  margin-top: 16px; // Add space between buttons
  
  img {
    height: 48px;
    width: auto;
    display: block;
  }

  &:hover {
    transform: translateY(-2px);
  }
`;

const StoreButtons = () => {
  return (
    <ButtonContainer>
      <StoreButton 
        href="https://play.google.com/store" 
        target="_blank" 
        rel="noopener noreferrer"
      >
        <img 
          src="/img/store/android.png" 
          alt="Get it on Google Play"
        />
      </StoreButton>
      
      <StoreButton 
        href="https://apps.apple.com/app/your-app-id" 
        target="_blank" 
        rel="noopener noreferrer"
      >
        <img 
          src="/img/store/Apple.svg" 
          alt="Download on the App Store"
        />
      </StoreButton>
    </ButtonContainer>
  );
};

export default StoreButtons;