import styled from "styled-components";

export const TeamSection = styled.section`
  padding: 5rem 0;
  text-align: center;
  background: white;
  border-radius: 10px;
  margin: 2rem;
  box-shadow: 0 4px 8px rgba(143, 229, 192, 0.2);
`;

export const MemberCard = styled.div`
  margin-bottom: 2rem;
  transition: all 0.3s ease;
  padding: 1.5rem;
  border-radius: 8px;
  
  &:hover {
    transform: translateY(-5px);
    box-shadow: 0 6px 12px rgba(143, 229, 192, 0.3);
  }
`;

export const MemberImage = styled.img`
  width: 200px;
  height: 200px;
  border-radius: 50%;
  object-fit: cover;
  margin-bottom: 1rem;
  box-shadow: 0 4px 8px rgba(143, 229, 192, 0.2);
  transition: all 0.3s ease;
  outline: 3px solid rgba(143, 229, 192, 0.3);
  outline-offset: 3px;

  &:hover {
    transform: scale(1.05);
    box-shadow: 0 6px 12px rgba(143, 229, 192, 0.3);
    outline-color: rgba(143, 229, 192, 0.6);
  }
`;

export const MemberName = styled.h3`
  font-size: 1.5rem;
  margin: 0.5rem 0;
  color: #000;
`;

export const MemberRole = styled.p`
  color: rgb(143, 229, 192);
  margin: 0;
  font-weight: normal;
`;

export const SocialLinks = styled.div`
  margin-top: 1rem;
`;

export const LinkedInButton = styled.a`
  display: inline-flex;
  align-items: center;
  padding: 8px 16px;
  background: #0077b5;
  color: white;
  border-radius: 4px;
  text-decoration: none;
  font-size: 14px;
  transition: background 0.3s ease;

  &:hover {
    background: #005f93;
  }

  svg {
    margin-right: 8px;
  }
`;