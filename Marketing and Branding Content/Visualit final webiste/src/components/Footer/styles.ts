import styled from "styled-components";
import { Link } from "react-router-dom";

export const FooterSection = styled("footer")`
  background: rgb(255, 255, 255);
  padding: 2.5rem 0;
`;

export const Title = styled("h4")`
  font-size: 22px;
  text-transform: capitalize;
  color:rgb(0, 0, 0);

  @media screen and (max-width: 414px) {
    padding: 1.5rem 0;
  }
`;

export const NavLink = styled(Link)`
  display: block;
  font-size: 1rem;
  margin-bottom: 0.625rem;
  transition: all 0.2s ease-in-out;

  &:hover,
  &:active,
  &:focus {
    color: rgb(143, 229, 192);  // Changed to green
  }
`;

export const Extra = styled("section")`
  background: rgb(255, 255, 255);
  position: relative;
  width: 100%;
  margin-right: auto;
  margin-left: auto;
  padding-bottom: 2rem;
  padding-top: 2rem;  // Keep padding but remove border-top
`;

export const LogoContainer = styled("div")`
  display: flex;
  position: relative;
`;

export const Para = styled("div")`
  color:rgb(0, 0, 0);
  font-size: 14px;
  width: 70%;
`;

export const Large = styled(Link)`
  font-size: 16px;
  color: #000;
  cursor: pointer;
  transition: all 0.3s ease-in-out;
  text-transform: capitalize;
  line-height: 24px;
  display: block;
  margin-bottom: 0.625rem;
  max-width: max-content;

  &:hover {
    color: rgb(143, 229, 192);  // Changed to green
    text-underline-position: under;
    text-decoration: rgb(143, 229, 192) wavy underline;  // Changed to green
  }
`;

export const Chat = styled("p")`
  color: #000;
  max-width: fit-content;
  border-bottom: 1px solid rgb(143, 229, 192);  // Changed to green
  cursor: pointer;
  margin-top: 1rem;
  transition: all 0.3s ease-in-out;

  &:hover {
    border-bottom: 1px solid rgb(143, 229, 192);  // Changed to green
    color: rgb(143, 229, 192);  // Changed to green
  }
`;

export const Empty = styled("div")`
  position: relative;
  height: 53px;
`;

export const FooterContainer = styled("div")`
  max-width: 510px;
  width: 100%;
  display: flex;
  justify-content: space-between;
  text-align: center;
  align-items: center;
  transition: all 0.1s ease-in-out;

  a {
    &:hover,
    &:active,
    &:focus {
      -webkit-transform: scale(1.1);
      -ms-transform: scale(1.1);
      transform: scale(1.1);
    }
  }

  @media screen and (max-width: 769px) {
    width: auto;

    a:not(:last-child) {
      display: none;
    }
  }

  div {
    cursor: pointer;
    margin-right: 15px;
    width: 25px;
    height: 25px;

    &:hover {
      fill: rgb(143, 229, 192);  // Changed to green
    }
  }
`;

export const Language = styled("h4")`
  font-size: 22px;
  text-transform: capitalize;
  color:rgb(0, 0, 0);

  @media screen and (max-width: 414px) {
    padding: 1.5rem 0;
  }
`;

export const Label = styled("label")`
  font-size: 22px;
  text-transform: capitalize;
  color:rgb(0, 0, 0);
  display: block;
  margin-bottom: 2rem;
  font-family: "Motiva Sans Bold", serif;

  @media screen and (max-width: 414px) {
    padding: 1.5rem 0;
    margin-bottom: 1rem;
  }
`;

export const LanguageSwitch = styled("div")`
  cursor: pointer;
  transition: all 0.1s ease-in-out;

  &:hover,
  &:active,
  &:focus {
    color: rgb(143, 229, 192);  // Changed to green
    transform: scale(1.1);
  }
`;

export const LanguageSwitchContainer = styled("div")`
  display: flex;
  justify-content: space-between;
  width: 85px;
`;

export const Divider = styled("div")`
  width: 100%;
  height: 2px;
  background: rgb(143, 229, 192);  // Changed from black to green
  margin: 2rem 0;
`;