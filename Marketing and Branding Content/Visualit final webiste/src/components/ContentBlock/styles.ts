import { Row } from "antd";
import styled from "styled-components";

export const ContentSection = styled("section")`
  position: relative;
  padding: 10rem 0 8rem;

  @media only screen and (max-width: 1024px) {
    padding: 4rem 0 4rem;
  }
`;

export const Content = styled("p")`
  margin: 1.5rem 0 2rem 0;
  text-align: left;
`;

export const StyledRow = styled(Row)`
  flex-direction: ${({ direction }: { direction: string }) =>
    direction === "left" ? "row" : "row-reverse"};
`;

export const ContentWrapper = styled("div")`
  position: relative;
  max-width: 540px;
  text-align: center;  // Changed to center
  display: flex;
  flex-direction: column;
  align-items: center;  // Added to center all content

  @media only screen and (max-width: 575px) {
    padding-top: 4rem;
  }
`;

export const ServiceWrapper = styled("div")`
  display: flex;
  justify-content: space-between;
  max-width: 100%;
`;

export const MinTitle = styled("h6")`
  font-size: 15px;
  line-height: 1rem;
  padding: 0.5rem 0;
  text-transform: uppercase;
  color: #000;
  font-family: "Motiva Sans Light", sans-serif;
`;

export const MinPara = styled("p")`
  font-size: 13px;
`;

export const ButtonWrapper = styled("div")`
  display: flex;
  flex-direction: column;
  align-items: center;  // Changed from flex-start to center
  gap: 20px;
  width: 100%;  // Changed from max-width to width
  margin: 0 auto;  // Added to help with centering

  @media screen and (min-width: 1024px) {
    width: 80%;  // Changed from max-width to width
  }

  button {
    width: 200px;
    justify-content: center;
    margin: 0 auto;  // Added to ensure button centering
  }

  // Container for store buttons
  div {
    display: flex;
    flex-direction: column;
    align-items: center;  // Added to center store buttons
    gap: 10px;
    width: 200px;
  }
`;
