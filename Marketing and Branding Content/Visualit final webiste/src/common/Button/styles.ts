import styled from "styled-components";

export const StyledButton = styled("button")<{ color?: string }>`
  background: ${(p) => p.color || "white"};
  color: ${(p) => (p.color ? "#2E186A" : "#000")};
  font-size: 1rem;
  font-weight: 700;
  width: 100%;
  border: 2px solid rgb(143, 229, 192);
  border-radius: 4px;
  padding: 13px 0;
  cursor: pointer;
  margin-top: 0.625rem;
  max-width: 180px;
  transition: all 0.3s ease-in-out;
  box-shadow: 0 4px 8px rgba(143, 229, 192, 0.2);

  &:hover,
  &:active,
  &:focus {
    color: #fff;
    border: 2px solid rgb(143, 229, 192);
    background-color: rgb(143, 229, 192);
    transform: translateY(-2px);
    box-shadow: 0 6px 12px rgba(143, 229, 192, 0.3);
  }
`;
